function R_all = svd_rigid_rotation_timeseries(static_markers, dynamic_markers)
% Computes rigid-body rotation matrices for a time series using SVD
%
% static_markers  : Nx3 matrix (reference markers from static trial)
% dynamic_markers : Nx3xT matrix (markers from dynamic trial over time)
%
% R_all : 3x3xT rotation matrices mapping STATIC → DYNAMIC for each frame

    [N, ~, T] = size(dynamic_markers);

    % --- marker number check ---
    if size(static_markers,1) ~= N
        error('Number of markers must match between static and dynamic.');
    end

    % --- center static markers ---
    static_centered = static_markers - mean(static_markers,1);

    % --- prepare output (preallocation) ---
    R_all = zeros(3,3,T);

    for t = 1:T

        % ---- 1. center dynamic markers at frame t ----
        dyn_t = dynamic_markers(:,:,t);
        dyn_centered = dyn_t - mean(dyn_t,1);

        % ---- 2. correlation matrix (preparation for SVD)----
        H = static_centered' * dyn_centered;

        % ---- 3. SVD ----
        [U,~,V] = svd(H);

        % ---- 4. rotation matrix ----
        R = V * U';

        % ---- 5. ensure det(R)=+1 ----
        if det(R) < 0
            V(:,3) = -V(:,3);
            R = V * U';
        end

        % ---- store ----
        R_all(:,:,t) = R;
    end
end