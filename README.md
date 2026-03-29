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


### 3. Biodex Data Importer (import_biodex_data.m)

A parser for ASCII files exported from the Biodex System 3.
Automated Data Extraction: Parses header info (Subject ID, Joint, Mode) and organizes time-series data into a structured MATLAB format.
Unit Conversion: Automatically scales raw values and converts Torque from lb-ft to Newton-Meters (Nm).

- **Workflow**:
  Data import → Unit conversion, Value scaling → Export (MATLAB format).

-**Usage**
```matlab
% Inputs:
% base_path: directory containing subject folders (e.g., '001/hip/')
% subj_list: array of subject IDs e.g., [8, 12]
%
% Returns:
%   all_data  - Struct containing parsed data organized by subject and condition.
```

# Technical Note and Work in Progress

The functions shared here are a subset of a larger biomechanics data pipeline.
- Private Repository: The core musculoskeletal modeling engine and primary research datasets are currently maintained in a private repository due to ongoing PhD research and data privacy requirements.
- Under Development: Additional tools for force estimation and automated scaling are currently undergoing validation and code refactoring. They will be integrated into this collection once they meet my standards for production-quality implementation and documentation.
  
NTanaka

---
