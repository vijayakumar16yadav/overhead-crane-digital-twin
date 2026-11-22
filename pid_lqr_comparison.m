
clc;
clear;
close all;

%% PID VS LQR PERFORMANCE COMPARISON
% AI-Based Overhead Crane Digital Twin

%% LOAD SIMULATION RESULTS

P = load('pid_results_60s.mat');
L = load('lqr_results.mat');

% Extract simulation data
tp = P.t(:);
tl = L.t(:);

xp = P.z(:,1);
xl = L.z(:,1);

% Swing angles are already in degrees in saved results
thetap = P.theta(:);
thetal = L.theta(:);

% Target trolley position
target = 2;

%% PERFORMANCE CALCULATIONS

% Final position errors
pid_error = abs(target-xp(end));
lqr_error = abs(target-xl(end));

% Maximum absolute swing angles
pid_swing = max(abs(thetap));
lqr_swing = max(abs(thetal));

% Settling times (2% tolerance)
pid_settling = calculateSettlingTime(tp,xp,target);
lqr_settling = calculateSettlingTime(tl,xl,target);

%% CREATE PROFESSIONAL DASHBOARD

fig = figure( ...
    'Name','AI-Based Digital Twin - PID vs LQR', ...
    'Color','w', ...
    'Position',[50 50 1450 900]);

%% GRAPH 1: TROLLEY POSITION

subplot(2,2,1);

plot(tp,xp,'b','LineWidth',2.2);
hold on;

plot(tl,xl,'r','LineWidth',2.2);

yline(target,'k--','Target Position', ...
    'LineWidth',1.5);

grid on;
box on;

title('Trolley Position Comparison', ...
    'Color','k','FontSize',15,'FontWeight','bold');

xlabel('Time (seconds)','Color','k');
ylabel('Position (m)','Color','k');

legend('PID','LQR','Target', ...
    'Location','best');

%% GRAPH 2: LOAD SWING

subplot(2,2,2);

plot(tp,thetap,'b','LineWidth',2.2);
hold on;

plot(tl,thetal,'r','LineWidth',2.2);

yline(0,'k--','LineWidth',1);

grid on;
box on;

title('Load Swing Comparison', ...
    'Color','k','FontSize',15,'FontWeight','bold');

xlabel('Time (seconds)','Color','k');
ylabel('Swing Angle (degrees)','Color','k');

legend('PID','LQR','Location','best');

%% GRAPH 3: POSITION TRACKING ERROR

subplot(2,2,3);

plot(tp,abs(target-xp),'b','LineWidth',2.2);
hold on;

plot(tl,abs(target-xl),'r','LineWidth',2.2);

grid on;
box on;

title('Position Tracking Error', ...
    'Color','k','FontSize',15,'FontWeight','bold');

xlabel('Time (seconds)','Color','k');
ylabel('Absolute Error (m)','Color','k');

legend('PID','LQR','Location','best');

%% GRAPH 4: PERFORMANCE METRICS

subplot(2,2,4);

axis off;

title('Controller Performance Summary', ...
    'Color','k','FontSize',15,'FontWeight','bold');

metricText = {
    'PERFORMANCE PARAMETER       PID             LQR'
    '------------------------------------------------'
    sprintf('Final Position Error       %.4f m        %.4f m', ...
        pid_error,lqr_error)
    sprintf('Maximum Swing Angle        %.4f deg      %.4f deg', ...
        pid_swing,lqr_swing)
    sprintf('Settling Time               %.2f s         %.2f s', ...
        pid_settling,lqr_settling)
    '------------------------------------------------'
    'Blue = PID Controller'
    'Red  = LQR Controller'
    };

text(0.03,0.85,metricText, ...
    'Units','normalized', ...
    'FontName','FixedWidth', ...
    'FontSize',11, ...
    'FontWeight','bold', ...
    'Color','k', ...
    'VerticalAlignment','top');

%% MAIN TITLE

sgtitle('AI-Based Digital Twin: PID vs LQR Comparison', ...
    'Color','k', ...
    'FontSize',19, ...
    'FontWeight','bold');

%% PROFESSIONAL DARK FONT STYLING

axs = findall(fig,'Type','axes');

for k = 1:length(axs)

    set(axs(k), ...
        'Color','w', ...
        'XColor',[0 0 0], ...
        'YColor',[0 0 0], ...
        'FontSize',12, ...
        'FontWeight','bold', ...
        'LineWidth',1.4, ...
        'GridColor',[0.35 0.35 0.35], ...
        'GridAlpha',0.3);

end

%% DISPLAY PERFORMANCE RESULTS

fprintf('\n====================================\n');
fprintf('       PID VS LQR COMPARISON\n');
fprintf('====================================\n');

fprintf('\nPID RESULTS\n');
fprintf('Final Position Error: %.4f m\n',pid_error);
fprintf('Maximum Swing: %.4f degrees\n',pid_swing);
fprintf('Settling Time: %.2f seconds\n',pid_settling);

fprintf('\nLQR RESULTS\n');
fprintf('Final Position Error: %.4f m\n',lqr_error);
fprintf('Maximum Swing: %.4f degrees\n',lqr_swing);
fprintf('Settling Time: %.2f seconds\n',lqr_settling);

fprintf('\nComparison Completed Successfully!\n');

%% SETTLING TIME FUNCTION

function ts = calculateSettlingTime(t,x,target)

tolerance = 0.02*abs(target);

error = abs(x-target);

idx = find(error > tolerance,1,'last');

if isempty(idx)

    ts = 0;

elseif idx == length(t)

    ts = NaN;

else

    ts = t(idx+1);

end

end
