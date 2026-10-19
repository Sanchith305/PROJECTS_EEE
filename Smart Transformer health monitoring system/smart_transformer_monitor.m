%% SMART TRANSFORMER HEALTH MONITORING SYSTEM
% MATLAB R2026a
% Monitor transformer voltage, current, and load.
% Detect abnormal operating conditions using basic threshold logic.

clc;
clear;
close all;

T = 60;
Fs = 10;
t = 0:1/Fs:T;
N = numel(t);

Vrated = 230;      % V
Irated = 10;       % A
Vmin = 210;        % V
Vmax = 250;        % V
Iwarning = 9;      % A
Icritical = 10;    % A

rng(1);

voltage = Vrated + 2*sin(2*pi*0.05*t) + 0.8*randn(size(t));
current = 5.5 + 0.4*sin(2*pi*0.08*t) + 0.15*randn(size(t));
loadPercent = (current/Irated)*100;

% Overload: 15-25 s
idx1 = t >= 15 & t < 25;
current(idx1) = 10.8 + 0.25*sin(2*pi*0.1*t(idx1)) ...
              + 0.1*randn(1,sum(idx1));

% Abnormal voltage: 30-38 s
idx2 = t >= 30 & t < 38;
voltage(idx2) = 255 + 1.5*sin(2*pi*0.08*t(idx2)) ...
              + 0.5*randn(1,sum(idx2));

% Severe overload: 45-53 s
idx3 = t >= 45 & t < 53;
current(idx3) = 11.8 + 0.3*sin(2*pi*0.1*t(idx3)) ...
              + 0.1*randn(1,sum(idx3));

loadPercent = (current/Irated)*100;

% Fault codes:
% 0 Normal, 1 Voltage Abnormal, 2 Load Warning,
% 3 Overload, 4 Multiple Fault
faultCode = zeros(size(t));

for k = 1:N
    voltageFault = voltage(k) < Vmin || voltage(k) > Vmax;
    loadWarning = current(k) > Iwarning || loadPercent(k) > 90;
    loadCritical = current(k) > Icritical || loadPercent(k) > 100;

    if voltageFault && loadCritical
        faultCode(k) = 4;
    elseif voltageFault
        faultCode(k) = 1;
    elseif loadCritical
        faultCode(k) = 3;
    elseif loadWarning
        faultCode(k) = 2;
    end
end

if any(faultCode == 4)
    overallStatus = "MULTIPLE ABNORMAL CONDITIONS";
elseif any(faultCode == 3)
    overallStatus = "OVERLOAD DETECTED";
elseif any(faultCode == 2)
    overallStatus = "LOAD WARNING";
elseif any(faultCode == 1)
    overallStatus = "VOLTAGE ABNORMALITY";
else
    overallStatus = "NORMAL";
end

fprintf('\n');
fprintf('SMART TRANSFORMER HEALTH MONITORING SYSTEM\n');
fprintf('Rated Voltage: %.2f V\n',Vrated);
fprintf('Rated Current: %.2f A\n',Irated);
fprintf('Minimum Voltage: %.2f V\n',min(voltage));
fprintf('Maximum Voltage: %.2f V\n',max(voltage));
fprintf('Maximum Current: %.2f A\n',max(current));
fprintf('Maximum Load: %.2f %%\n',max(loadPercent));
fprintf('Overall Status: %s\n\n',overallStatus);

voltageColor = [0.00 0.45 0.74];
currentColor = [0.85 0.33 0.10];
loadColor = [0.47 0.67 0.19];
faultColor = [0.64 0.08 0.18];
limitColor = [0.35 0.35 0.35];

figure('Name','Smart Transformer Health Monitoring System', ...
       'NumberTitle','off','Color','white','Position',[100 50 1300 850]);

sgtitle('SMART TRANSFORMER HEALTH MONITORING SYSTEM', ...
        'FontSize',20,'FontWeight','bold');

ax1 = subplot(4,1,1);
plot(t,voltage,'Color',voltageColor,'LineWidth',2); hold on;
yline(Vrated,'--','Color',limitColor,'LineWidth',1.2);
yline(Vmin,':','Color',limitColor,'LineWidth',1);
yline(Vmax,':','Color',limitColor,'LineWidth',1);
title('Transformer Voltage Monitoring','FontWeight','bold');
ylabel('Voltage (V)'); grid on; box on;
legend('Voltage','Rated Voltage','Limits','Location','southwest');

ax2 = subplot(4,1,2);
plot(t,current,'Color',currentColor,'LineWidth',2); hold on;
yline(Irated,'--','Color',limitColor,'LineWidth',1.2);
yline(Iwarning,':','Color',limitColor,'LineWidth',1);
yline(Icritical,':','Color',limitColor,'LineWidth',1);
title('Transformer Current Monitoring','FontWeight','bold');
ylabel('Current (A)'); grid on; box on;
legend('Current','Rated Current','Limits','Location','southwest');

ax3 = subplot(4,1,3);
plot(t,loadPercent,'Color',loadColor,'LineWidth',2); hold on;
yline(100,'--','Color',limitColor,'LineWidth',1.2);
yline(90,':','Color',limitColor,'LineWidth',1);
title('Transformer Loading','FontWeight','bold');
ylabel('Load (%)'); grid on; box on;
legend('Transformer Load','100% Rated','90% Warning','Location','southwest');

ax4 = subplot(4,1,4);
stairs(t,faultCode,'Color',faultColor,'LineWidth',2.5);
title('Transformer Fault Indication','FontWeight','bold');
xlabel('Time (s)'); ylabel('Status'); grid on; box on;
yticks(0:4);
yticklabels({'Normal','Voltage Abnormal','Load Warning','Overload','Multiple Fault'});
ylim([-0.5 4.5]);

for x = [15 25 45 53]
    xline(ax2,x,'--','Color',faultColor,'LineWidth',1.1,'HandleVisibility','off');
end
for x = [30 38]
    xline(ax1,x,'--','Color',faultColor,'LineWidth',1.1,'HandleVisibility','off');
end
linkaxes([ax1 ax2 ax3 ax4],'x');

fprintf('Monitoring completed successfully.\n');
