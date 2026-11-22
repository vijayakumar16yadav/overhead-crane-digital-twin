
clc;
clear;
close all;

% Load crane parameters
run('parameters.m');

% PID controller gains
pid.Kp = 500;
pid.Ki = 10;
pid.Kd = 1000;

% Anti-sway gains
pid.Ktheta = 1000;
pid.Komega = 1000;

% Initial conditions
z0 = [p.x0; p.v0; p.theta0; p.omega0; 0];

% Run PID controlled simulation
[t,z] = ode45(@(t,z) ...
    pid_simulation_model(t,z,pid,p), ...
    [0 60], z0);

% Extract results
x = z(:,1);
theta = z(:,3)*180/pi;

% Plot results
figure('Name','PID Controlled Crane');

subplot(2,1,1);
plot(t,x,'LineWidth',1.5);
grid on;
xlabel('Time (seconds)');
ylabel('Position (m)');
title('PID Controlled Trolley Movement');

subplot(2,1,2);
plot(t,theta,'LineWidth',1.5);
grid on;
xlabel('Time (seconds)');
ylabel('Swing Angle (degrees)');
title('PID Controlled Load Swing');

disp('PID Simulation Completed Successfully');
