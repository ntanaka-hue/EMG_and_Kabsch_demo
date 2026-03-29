function all_data = import_biodex_data(base_path, subj_list)
% IMPORT_BIODEX_DATA Simplified importer for Biodex System exported text files.
% 
% This function performs basic unit conversion and scaling without 
% applying any joint-specific normalization or offset corrections.
%
% Inputs:
% base_path: directory containing subject folders (e.g., '001/hip/')
% subj_list: array of subject IDs e.g., [8, 12]
%
% Returns:
%   all_data  - Struct containing parsed data organized by subject and condition.


    all_data = struct();
    jnt_names = {'hip', 'knee', 'ankle'};
    
    % Conversion constants
    LB_TO_NM = 1.3558;   % ft-lb to Nm conversion factor
    SCALE_FACTOR = 0.1;  % Correction for Biodex 10x output scale

    for subj = subj_list
        for jnt_idx = 1:3
            curr_jnt = jnt_names{jnt_idx};
            
            % Construct folder path for specific subject and joint
            dat_path = fullfile(base_path, num2str(subj, '%.3d'), curr_jnt);
            
            if ~exist(dat_path, 'dir'), continue; end
            
            fileList = dir(fullfile(dat_path, '*.txt'));
            if isempty(fileList), continue; end

            for i = 1:length(fileList)
                % Skip temporary or malformed files containing underscores
                if contains(fileList(i).name, '_'), continue; end
                
                target_file = fullfile(dat_path, fileList(i).name);
                all_data = parse_biodex_file(target_file, all_data, LB_TO_NM, SCALE_FACTOR);
            end
        end
    end
end

function data_struct = parse_biodex_file(file_path, data_struct, lb_to_nm, scale)
    % Open file for reading
    fid = fopen(file_path, 'r');
    if fid == -1, return; end

    try
        % Read header line: e.g., 012,,10/07/25,16:16:43,UNI,HIP,ABD/ADD,ISOM,AGONIST/ANTAGONIST,2
        headerLine = fgetl(fid);
        if ~ischar(headerLine), fclose(fid); return; end
        
        h = strsplit(headerLine, ',');
        if length(h) < 8, fclose(fid); return; end
        
        subjID = str2double(h{1});
        mode = h{8}; % 'ISOK', 'ISOM', etc.
        numSets = str2double(h{end});
        
        % Determine the starting index for mapping trials to conditions
        base_cond = determine_base_condition(h);

        for s = 1:numSets
            % Skip set information line (e.g., "1,0,16500")
            if ~ischar(fgetl(fid)), break; end
            
            % Read data line (A long single line of comma-separated values)
            dataLine = fgetl(fid);
            if ~ischar(dataLine) || isempty(dataLine), break; end
            
            % textscan extracts all numbers into a cell array
            rawVals = textscan(dataLine, '%f', 'Delimiter', ',');
            if isempty(rawVals{1}), break; end
            
            % Biodex stores data in sets of 3: [Torque, Position, Velocity]
            num_elements = floor(length(rawVals{1}) / 3) * 3;
            dataMatrix = reshape(rawVals{1}(1:num_elements), 3, [])';
            
            % Convert to physical units
            torque_raw = dataMatrix(:,1);
            pos_raw    = dataMatrix(:,2);
            vel_raw    = dataMatrix(:,3);
            
            torque_Nm    = torque_raw * scale * lb_to_nm;
            position_deg = pos_raw * scale;
            velocity_deg = vel_raw * scale;

            % Store in the output struct
            cond_idx = base_cond + s - 1;
            suffix = 'd'; 
            if strcmp(mode, 'ISOM'), suffix = 's'; end
            
            % Construct field name (e.g., g01s012s01s)
            dataname = sprintf('g01s%03ds%02d%s', subjID, cond_idx, suffix);

            data_struct.(dataname).data = [position_deg, torque_Nm, velocity_deg];
            data_struct.(dataname).header = h;
        end
    catch ME
        fprintf('Error parsing file %s: %s\n', file_path, ME.message);
    end
    fclose(fid);
end

function cond_b = determine_base_condition(h)
    % Map joint and test mode to a specific starting condition index.
    % Based on file header: h{6}=Joint, h{7}=Movement, h{8}=Mode, h{9}=Type
    if length(h) < 9, cond_b = 1; return; end
    
    jnt  = h{6};  % HIP, KNEE, ANKLE
    mvmt = h{7};  % ABD/ADD, FLX/EXT, PF/DF, etc.
    mode = h{8};  % ISOM, ISOK
    type = h{9};  % AGONIST/ANTAGONIST, CON/CON, etc.
    
    cond_b = 1;
    
    if strcmp(mode, 'ISOM')
        % Specific start indices for Isometric trials
        if strcmp(jnt,'HIP')
            if contains(mvmt, 'FLX/EXT')
                cond_b = 3; % Example: Shift index for Hip Flexion/Extension
            else
                cond_b = 1; % Default for Hip ABD/ADD
            end
        elseif strcmp(jnt,'KNEE'), cond_b = 5;
        elseif strcmp(jnt,'ANKLE'), cond_b = 7;
        end
    else
        % Dynamic trial index assignment (ISOK/ISOT)
        if strcmp(jnt,'KNEE')
            if contains(type,'CON/CON'), cond_b = 1;
            elseif contains(type,'CON/ECC'), cond_b = 3;
            else, cond_b = 5;
            end
        else % Ankle / Hip
            if contains(type,'CON/CON'), cond_b = 7;
            elseif contains(type,'CON/ECC'), cond_b = 9;
            else, cond_b = 11;
            end
        end
    end
end
