# Overhead Crane Digital Twin

A MATLAB simulation project for modeling an industrial overhead crane and studying trolley position control and suspended-load sway. It includes a nonlinear crane model, PID anti-sway control, integral LQR control, controller comparisons, and a 3D animation based on saved LQR results.

## Project overview

The crane is modeled as a trolley carrying a suspended load. The nonlinear equations describe trolley motion, cable angle, and their accelerations. The default parameters are a 500 kg trolley, 100 kg load, 2 m cable, 5-degree initial cable angle, and a 2 m target trolley position.

Two feedback approaches are included:

- **PID with anti-sway feedback:** uses position error, integral action, trolley velocity, load angle, and angular velocity to calculate the trolley force.
- **LQR with integral action:** uses a linearized crane model and a weighted state-feedback controller to track the target position while limiting load swing.

The simulation scripts use MATLAB `ode45`. Results can be plotted side by side using the comparison script, and the 3D animation visualizes the trolley and load motion using the saved LQR result file.

## Files

| File | Purpose |
| --- | --- |
| `parameters.m` | Crane physical parameters, target position, and initial conditions |
| `crane_model.m` | Nonlinear overhead-crane equations of motion |
| `simulation.m` | Uncontrolled crane simulation (run `parameters.m` first) |
| `pid_controller.m` | PID position control with anti-sway feedback |
| `pid_simulation_model.m` | Dynamics used by the PID simulation |
| `simulation_pid.m` | Runs and plots a 60-second PID simulation |
| `lqr_controller.m` | LQR state-feedback control law |
| `lqr_simulation_model.m` | Dynamics used by the LQR simulation |
| `simulation_lqr.m` | Designs the integral LQR controller, then runs and plots a 60-second simulation |
| `pid_lqr_comparison.m` | Compares saved PID and LQR results, including position error, swing angle, and settling time |
| `crane_3D_twin.m` | Animates the crane using `lqr_results.mat` |
| `pid_results.mat`, `pid_results_60s.mat`, `lqr_results.mat` | Saved simulation results used by the comparison and animation scripts |

## Getting started

1. Open this folder as the current folder in MATLAB.
2. Run `simulation_pid.m` or `simulation_lqr.m` to run a controller simulation and view its plots.
3. Run `pid_lqr_comparison.m` to compare the included saved results.
4. Run `crane_3D_twin.m` to play the 3D animation based on `lqr_results.mat`.

`simulation_lqr.m` uses MATLAB's `lqr` function, which requires Control System Toolbox. The comparison and animation scripts expect the included result files to remain in this folder.

## Notes

This is a simulation project. The 3D animation visualizes saved model output; it is not connected to physical crane hardware or a live industrial system.
