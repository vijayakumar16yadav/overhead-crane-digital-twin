
clc;
clear;

% OVERHEAD CRANE PARAMETERS

% Physical parameters
p.M = 500;       % Trolley mass (kg)
p.m = 100;       % Load mass (kg)
p.L = 2;         % Cable length (m)
p.g = 9.81;      % Gravitational acceleration (m/s^2)

% Trolley friction
p.b = 20;        % Damping coefficient (N.s/m)

% Desired trolley position
p.x_ref = 2;     % Target position (m)

% Simulation settings
p.t_end = 10;    % Total simulation time (seconds)
p.dt = 0.01;     % Time step (seconds)

% Initial conditions
p.x0 = 0;                  % Initial trolley position
p.v0 = 0;                  % Initial trolley velocity
p.theta0 = 5*pi/180;       % Initial swing angle (radians)
p.omega0 = 0;              % Initial angular velocity

disp('Crane Parameters Loaded Successfully');

disp(p);
