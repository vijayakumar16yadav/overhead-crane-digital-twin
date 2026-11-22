
function dz = pid_simulation_model(t, z, pid, p)

% PID CONTROLLED CRANE MODEL

% Calculate control force
F = pid_controller(z, pid, p);

% Calculate crane movement
dz = zeros(5,1);

dz(1:4) = crane_model(t, z(1:4), F, p);

% Integral of position error
dz(5) = p.x_ref - z(1);

end

