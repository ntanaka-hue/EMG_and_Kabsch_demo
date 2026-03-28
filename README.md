# EMG_and_Kabsch_demo (MATLAB)

This repository contains a collection of MATLAB utility functions developed during my PhD research at Iowa State University. 

## Contents

### 1. EMG Signal Processing (`emg_process.m`)
Provides a standard pipeline for processing raw EMG signals into linear envelopes.
- **Workflow**: 4th-order Butterworth bandpass filter (20–250 Hz) → Full-wave rectification → 4th-order Butterworth low-pass filter for smoothing.
- **Usage**: 

### 2. Rigid-Body Rotation Matrix Calculation (`rotation_matrix.m`)
Computes time-series rotation matrices mapping static reference markers to dynamic marker sets using Singular Value Decomposition (SVD).
- **Robustness (Handling Reflection)**: Includes a specific check for the determinant of the rotation matrix. If a reflection (left-handed system) is detected due to measurement noise or skin artifacts, the function automatically corrects it to a proper right-handed rotation matrix and logs a warning to the console:
  `Warning: Reflection detected and corrected at frame [t]`
- **Traceability**: This approach ensures the continuity of the data pipeline while maintaining high standards for data quality assessment.

---

## Technical Note & Work in Progress

The functions shared here are a subset of a larger biomechanics data pipeline. 

- **Private Repository**: The core musculoskeletal modeling engine and primary research datasets are currently maintained in a private repository due to ongoing PhD research and data privacy requirements.
- **Under Development**: Additional tools for force estimation and automated scaling are currently undergoing validation and code refactoring. They will be integrated into this collection once they meet my standards for production-quality implementation and documentation.

## About the Author
**Nozomu Tanaka** PhD Candidate in Kinesiology (Biomechanics) with 15+ years of experience in systems engineering (Bosch, TNO, Yamaha). I focus on building scalable, production-oriented software solutions for complex biomechanical problems.
