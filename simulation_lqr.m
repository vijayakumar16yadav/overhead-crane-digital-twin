
clc;
clear;
close all;

% Load crane parameters
run('parameters.m');

% Linearized crane model
M = p.M;
m = p.m;
L = p.L;
g = p.g;
b = p.b;

A = [0  1  0  0;
    0 -b/M m*g/M 0;
    0  0  0  1;
    0 b/(M*L) -(M+m)*g/(M*L) 0];

B = [0;
    1/M;
    0;
    -1/(M*L)];

% Add integral action for position tracking
A_aug = [A zeros(4,1);
    1 0 0 0 0];

B_aug = [B; 0];

% LQR weighting matrices
Q = diag([100 10 1000 100 10]);
R = 0.1;

% Calculate LQR gain
K = lqr(A_aug,B_aug,Q,R);

disp('LQR Gain Matrix:');
disp(K);

% Initial conditions
z0 = [p.x0; p.v0; p.theta0; p.omega0; 0];

% Run LQR simulation
[t,z] = ode45(@(t,z) ...
    lqr_simulation_model(t,z,K,p), ...
    [0 60], z0);

% Extract results
x = z(:,1);
theta = z(:,3)*180/pi;

% Plot results
figure('Name','LQR Controlled Crane');

subplot(2,1,1);
plot(t,x,'LineWidth',1.5);
grid on;
xlabel('Time (seconds)');
ylabel('Position (m)');
title('LQR Controlled Trolley Movement');

subplot(2,1,2);
plot(t,theta,'LineWidth',1.5);
grid on;
xlabel('Time (seconds)');
ylabel('Swing Angle (degrees)');
title('LQR Controlled Load Swing');

disp('LQR Simulation Completed Successfully');

disp('LQR Gain Values:');
disp(K);

disp('Final Trolley Position:');
disp(x(end));

disp('Final Swing Angle:');
disp(theta(end));

disp('Final Integral Error:');
disp(z(end,5));