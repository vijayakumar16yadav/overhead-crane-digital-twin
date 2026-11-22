
function dz = crane_model(t, z, F, p)

% OVERHEAD CRANE MATHEMATICAL MODEL

% State variables
x = z(1);
v = z(2);
theta = z(3);
omega = z(4);

% Mass and system parameters
M = p.M;
m = p.m;
L = p.L;
g = p.g;
b = p.b;

% Matrix of equations
A = [M+m,       m*L*cos(theta);
    m*L*cos(theta), m*L^2];

% Right-hand side
B = [F - b*v + m*L*sin(theta)*omega^2;
    -m*g*L*sin(theta)];

% Calculate accelerations
acc = A\B;

xdd = acc(1);
thetadd = acc(2);

% State derivatives
dz = zeros(4,1);

dz(1) = v;
dz(2) = xdd;
dz(3) = omega;
dz(4) = thetadd;

end
