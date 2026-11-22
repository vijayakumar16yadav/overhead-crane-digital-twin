
clc;
clear;
close all;

%% 3D INDUSTRIAL OVERHEAD CRANE DIGITAL TWIN

run('parameters.m');

% Load actual LQR simulation results
S = load('lqr_results.mat');

t = S.t(:);
z = S.z;

x = z(:,1);
theta = z(:,3);

% Crane dimensions
H = 3;
L = p.L;

xmin = min([0; x])-1;
xmax = max([p.x_ref; x])+1;

railY = 0.65;

%% CREATE PROFESSIONAL FIGURE

fig = figure('Name','Industrial Crane Digital Twin', ...
    'Color',[0.96 0.97 0.98], ...
    'Position',[100 80 1200 750]);

ax = axes(fig);

hold(ax,'on');
grid(ax,'on');
box(ax,'on');

set(ax, ...
    'Color',[0.96 0.97 0.98], ...
    'XColor',[0.1 0.1 0.1], ...
    'YColor',[0.1 0.1 0.1], ...
    'ZColor',[0.1 0.1 0.1], ...
    'FontSize',12, ...
    'FontWeight','bold', ...
    'LineWidth',1.2);

xlabel(ax,'Trolley Movement (m)', ...
    'Color','k','FontSize',13,'FontWeight','bold');

ylabel(ax,'Crane Width (m)', ...
    'Color','k','FontSize',13,'FontWeight','bold');

zlabel(ax,'Height (m)', ...
    'Color','k','FontSize',13,'FontWeight','bold');

title(ax,'3D INDUSTRIAL OVERHEAD CRANE DIGITAL TWIN', ...
    'Color',[0.05 0.15 0.3], ...
    'FontSize',16,'FontWeight','bold');

view(ax,35,25);

xlim(ax,[xmin xmax]);
ylim(ax,[-1.5 1.5]);
zlim(ax,[0 3.8]);

axis(ax,'equal');

%% STEEL SUPPORTING COLUMNS

steel = [0.35 0.40 0.46];
blue = [0.05 0.25 0.65];

for xx = [xmin xmax]
    for yy = [-railY railY]

        createBox(ax,[xx yy H/2], ...
            [0.18 0.18 H],steel);

    end
end

%% HORIZONTAL STEEL RAILS

for yy = [-railY railY]

    createBox(ax,[(xmin+xmax)/2 yy H], ...
        [xmax-xmin 0.18 0.18],blue);

end

%% CROSS SUPPORT BEAMS

for xx = [xmin xmax]

    createBox(ax,[xx 0 H], ...
        [0.18 2*railY+0.18 0.18],steel);

end

%% TROLLEY BODY

td = [0.65 0.75 0.25];

trolley = createBox(ax,[x(1) 0 H+0.24], ...
    td,[0.95 0.55 0.08]);

%% TROLLEY WHEELS

wheelRadius = 0.11;
wheelWidth = 0.12;

wheelX = [-0.20 0.20];
wheelY = [-railY railY];

wheels = gobjects(4,1);
n = 0;

for i = 1:2
    for j = 1:2

        n = n+1;

        wheels(n) = createWheel(ax, ...
            x(1)+wheelX(i), ...
            wheelY(j), ...
            H+0.07, ...
            wheelRadius,wheelWidth);

    end
end

%% SUSPENDED LOAD

loadSize = [0.48 0.48 0.38];

initialLoadX = x(1)+L*sin(theta(1));
initialLoadZ = H-L*cos(theta(1));

loadObject = createBox(ax, ...
    [initialLoadX 0 initialLoadZ], ...
    loadSize,[0.85 0.12 0.08]);

%% SUSPENSION CABLE

cable = plot3(ax, ...
    [x(1) initialLoadX],[0 0], ...
    [H+0.10 initialLoadZ], ...
    'Color',[0.08 0.08 0.08], ...
    'LineWidth',3);

%% FLOOR

createBox(ax,[(xmin+xmax)/2 0 -0.12], ...
    [xmax-xmin+1 3.5 0.15], ...
    [0.72 0.75 0.78]);

%% LIGHTING AND MATERIAL

lighting(ax,'gouraud');
camlight(ax,'headlight');
material(ax,'metal');

%% ANIMATION

N = length(t);

step = max(1,floor(N/500));
frames = unique([1:step:N N]);

disp('Starting Industrial Crane Digital Twin...');

for k = frames

    % Current trolley position
    xpos = x(k);

    % Current swing angle
    angle = theta(k);

    % Load coordinates
    loadX = xpos+L*sin(angle);
    loadZ = H-L*cos(angle);

    % Update trolley
    updateBox(trolley,[xpos 0 H+0.24],td);

    % Update wheels
    n = 0;

    for i = 1:2
        for j = 1:2

            n = n+1;

            updateWheel(wheels(n), ...
                xpos+wheelX(i), ...
                wheelY(j), ...
                H+0.07, ...
                wheelRadius,wheelWidth);

        end
    end

    % Update suspended load
    updateBox(loadObject, ...
        [loadX 0 loadZ],loadSize);

    % Update cable
    set(cable, ...
        'XData',[xpos loadX], ...
        'YData',[0 0], ...
        'ZData',[H+0.10 loadZ]);

    title(ax,sprintf( ...
        'INDUSTRIAL CRANE DIGITAL TWIN | Time: %.2f s',t(k)), ...
        'Color',[0.05 0.15 0.3], ...
        'FontSize',15,'FontWeight','bold');

    drawnow;
    pause(0.02);

end

disp('3D Digital Twin Animation Completed Successfully');

%% LOCAL FUNCTIONS

function h = createBox(ax,center,dims,color)

V = boxVertices(center,dims);

F = [1 2 3 4;
     5 8 7 6;
     1 5 6 2;
     2 6 7 3;
     3 7 8 4;
     4 8 5 1];

h = patch(ax,'Vertices',V, ...
    'Faces',F, ...
    'FaceColor',color, ...
    'EdgeColor',[0.15 0.15 0.15], ...
    'LineWidth',0.8);

end

function updateBox(h,center,dims)

set(h,'Vertices',boxVertices(center,dims));

end

function V = boxVertices(c,d)

dx=d(1)/2;
dy=d(2)/2;
dz=d(3)/2;

V = [-dx -dy -dz;
      dx -dy -dz;
      dx  dy -dz;
     -dx  dy -dz;
     -dx -dy  dz;
      dx -dy  dz;
      dx  dy  dz;
     -dx  dy  dz];

V = V+c;

end

function h = createWheel(ax,cx,cy,cz,r,w)

[X,Y,Z] = cylinder(r,24);

% Orient cylinder along Y axis
h = surf(ax, ...
    cx+X, ...
    cy+(Z-0.5)*w, ...
    cz+Y, ...
    'FaceColor',[0.12 0.12 0.14], ...
    'EdgeColor','none');

end

function updateWheel(h,cx,cy,cz,r,w)

[X,Y,Z] = cylinder(r,24);

set(h, ...
    'XData',cx+X, ...
    'YData',cy+(Z-0.5)*w, ...
    'ZData',cz+Y);

end
