
function F = lqr_controller(z, K, p)

% LQR CONTROLLER

% State variables
x = z(1);
v = z(2);
theta = z(3);
omega = z(4);

% Integral error
integral_error = z(5);

% State error vector
e = [x - p.x_ref;
    v;
    theta;
    omega;
    integral_error];

% Calculate control force
F = -K * e;

end
