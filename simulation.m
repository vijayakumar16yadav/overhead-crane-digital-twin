
% STAGE 4: BASIC OVERHEAD CRANE SIMULATION

% Simulation time
tspan = [0 p.t_end];

% Initial conditions
z0 = [p.x0; p.v0; p.theta0; p.omega0];

% Run simulation without controller
[t,z] = ode45(@(t,z) crane_model(t,z,0,p), tspan, z0);

% Extract results
x = z(:,1);
theta = z(:,3)*180/pi;

% Plot results
figure('Name','Overhead Crane Simulation');

subplot(2,1,1);
plot(t,x,'LineWidth',1.5);
grid on;
xlabel('Time (seconds)');
ylabel('Trolley Position (m)');
title('Trolley Movement');

subplot(2,1,2);
plot(t,theta,'LineWidth',1.5);
grid on;
xlabel('Time (seconds)');
ylabel('Swing Angle (degrees)');
title('Load Swing');

disp('Basic Crane Simulation Completed Successfully');
