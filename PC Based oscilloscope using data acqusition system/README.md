# PC-Based Oscilloscope Using Data Acquisition System

MATLAB/Simulink academic project for displaying and analyzing electrical waveforms using a simulation-based data-acquisition chain.

## Main model

`PC_Oscilloscope_Simulation.slx`

## Exact model structure used in the project

```text
Sine Wave (10 V, 50 Hz) ----\
                              > Manual Switch 1 -> Gain -> Zero-Order Hold -> Scope
Pulse Generator (10 V, 50 Hz)/                         |                    |
                                                        |                    +-- Signal Statistics
                                                        v                    |   Max / Min / P-P / Mean / RMS
                                                 RMS Measurement            |
                                                        |                    +-- Waveform Cursors
                                                        v
                                                      Display

Prepared extension (not yet connected in the saved baseline model):
Sine Wave + Band-Limited White Noise -> Sum
```

## Parameters

### Sine Wave
- Amplitude = 10 V
- Bias = 0 V
- Frequency = 314.159 rad/s (approximately 50 Hz)
- Phase = 0
- Sample time = 0 s

### Pulse Generator
- Pulse type = Time based
- Time source = Use simulation time
- Amplitude = 10 V
- Period = 0.02 s
- Pulse width = 50%
- Phase delay = 0 s
- Interpret vector parameters as 1-D = enabled

### Gain
- Gain = 1
- Multiplication = Element-wise (K.*u)

### Zero-Order Hold
- Sample time = 0.001 s
- Equivalent sampling rate = 1 kHz

### RMS Measurement
- Base frequency = 50 Hz
- Specify harmonics = disabled
- Sample time = 0.001 s
- Mode = Discrete

### Scope
Signal Statistics used:
- Max
- Min
- Peak to Peak
- Mean
- RMS

Waveform Cursors used:
- Vertical cursor
- Show Measurement
- Snap to data

### Band-Limited White Noise (prepared extension)
- Noise power = 0.05
- Sample time = 0.001 s
- Seed = 23341
- Interpret vector parameters as 1-D = enabled

## Validated results

### Sine test
- Maximum ≈ 10 V
- Minimum ≈ -10 V
- Peak-to-peak ≈ 20 V
- RMS ≈ 7.071 V
- Period = 0.0200 s
- Frequency = 50 Hz

### Pulse test
- Maximum ≈ 10 V
- Minimum ≈ 0 V
- Peak-to-peak ≈ 10 V
- RMS ≈ 7.106 V
- Period = 0.0200 s
- Frequency = 50 Hz

## Hardware scope

This repository is intentionally simulation-based. No Arduino or physical DAQ hardware is required.

## Software

MATLAB R2026a with Simulink.
