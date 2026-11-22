
function dz = lqr_simulation_model(t, z, K, p)

% LQR CONTROLLED CRANE MODEL

% Calculate LQR control force
F = lqr_controller(z, K, p);

% Calculate crane movement
dz = zeros(5,1);

dz(1:4) = crane_model(t, z(1:4), F, p);

% Integral of position error
dz(5) = z(1) - p.x_ref;

end
