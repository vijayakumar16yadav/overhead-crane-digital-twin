
function F = pid_controller(z, pid, p)

% PID WITH ANTI-SWAY FEEDBACK

% State variables
x = z(1);
v = z(2);
theta = z(3);
omega = z(4);

% Integral error
integral_error = z(5);

% Position error
error = p.x_ref - x;

% Position PID control
F_position = pid.Kp*error ...
    + pid.Ki*integral_error ...
    - pid.Kd*v;

% Anti-sway feedback
F_sway = pid.Ktheta*theta ...
    + pid.Komega*omega;

% Total control force
F = F_position + F_sway;

end
