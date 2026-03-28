function emg_processed = emg_process(raw_emg, fs, lowpass_hz)
    cut_off_freqs = [20, 250]; % cutoff frequencies for bandpass filter [Hz]
    bp_order = 4; % order for bandpass Butterworth filter
    lp_order = 4; % order for low-pass Butterworth filter
% EMG preprocessing
% 20 - 250 Hz bandpass filter
% rectification
% low pass filter (3rd argument)
% raw_emg     : raw EMG data (voltage)
% fs          : sampling frequency [Hz]
% lowpass_hz  : cutoff frequency for the final smoothing [Hz]

    
    % ---- 1. Butterworth Bandpass (20–250 Hz) ----
    nyq = fs * 0.5;
    Wn = cut_off_freqs / nyq;   % normalized cutoff frequencies
    [b_bp, a_bp] = butter(bp_order, Wn, 'bandpass');
    emg_bp = filtfilt(b_bp, a_bp, raw_emg);

    % ---- 2. Rectification ----
    emg_rect = abs(emg_bp);
    % ---- 3. Butterworth Low-pass filter for envelope ----
    Wc = lowpass_hz / nyq;
    [b_lp, a_lp] = butter(lp_order, Wc, 'low');
    emg_processed = filtfilt(b_lp, a_lp, emg_rect);

end
