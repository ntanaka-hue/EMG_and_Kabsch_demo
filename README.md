# EMG_and_Kabsch_demo (MATLAB)

This repository contains MATLAB functions developed during my PhD research at Iowa State University.

## Contents

### 1. EMG Signal Processing (`emg_process.m`)
Provides a standard pipeline for processing raw EMG signals into linear envelopes.

- **Workflow**:  
  4th-order Butterworth bandpass filter (20–250 Hz) → Rectification → 4th-order Butterworth low-pass filter for smoothing.

- **Usage**:
```matlab
% EMG preprocessing
% 20 - 250 Hz bandpass filter
% rectification
% low pass filter (3rd argument)
% raw_emg     : raw EMG data (voltage)
% fs          : sampling frequency [Hz]
% lowpass_hz  : cutoff frequency for the final smoothing [Hz]
```

---

### 2. Rigid-Body Rotation Matrix Calculation (`rotation_matrix.m`)
Computes time-series rotation matrices mapping static reference markers to dynamic marker sets using Singular Value Decomposition (SVD).

- **Workflow**:  
  Subtract transport term → Correlation → SVD → Check det(R) < 0 → Extract rotation term.

- **Warning**:
```
Warning: Reflection detected and corrected at frame [t]
```

- **Usage**:
```matlab
% Computes rigid-body rotation matrices for a time series using SVD
%
% static_markers  : Nx3 matrix (reference markers from static trial)
% dynamic_markers : Nx3xT matrix (markers from dynamic trial over time)
%
% R_all : 3x3xT rotation matrices mapping STATIC → DYNAMIC for each frame
```

---

## Technical Note & Work in Progress
