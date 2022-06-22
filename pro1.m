% close all;
clear;
clc;
addpath(genpath('funcs'));

%% parameters
L0 = 0.5;
L1 = 0.15;
L2 = 0.1;
m1 = 0.6;
m2 = 0.5;
J1 = m1*L1^2/12;
J2 = m2*L2^2/12;

l1 = 0.05;
l2 = 0.025;
tau1 = 0.001;
tau2 = 0.001;

%% ODE求解
tspan = [0 50];
q0 = [0;pi/2;0;0];
odeOptions = odeset('RelTol',1e-3,'AbsTol',1e-5,'InitialStep',0.001,...
    'Events',@(t,y)isEnd(t,y,l1,l2));
[odet,odey,te,ye,ie] = ode45(@(t,y) newtonEuler(t,y,l1,l2,tau1,tau2), tspan, q0, odeOptions);
% 求解运动微分方程中的中间变量
[odeyd,rD,rE,rF,rG,rE_d,rF_d,rE_dd,rF_dd] = cellfun( ...
    @(t,y) newtonEuler(t,y.',l1,l2,tau1,tau2), num2cell(odet), num2cell(odey,2), 'uni', 0);
q = odey(:,1:2);
qd = odey(:,3:4);
qdd = transpose(cell2mat(odeyd'));
qdd = qdd(:,3:4);
rA = [-L0*0.6; 0];
rB = [L0*0.6; 0];
rC = [0; L0];
rD = transpose(cell2mat(rD'));
rE = transpose(cell2mat(rE'));
rF = transpose(cell2mat(rF'));
rG = transpose(cell2mat(rG'));
rE_d = transpose(cell2mat(rE_d'));
rF_d = transpose(cell2mat(rF_d'));
rE_dd = transpose(cell2mat(rE_dd'));
rF_dd = transpose(cell2mat(rF_dd'));
% E = cell2mat(E);
% [num,~] = getEndTime(odet,E,l1,l2);

%% 动画仿真
figure('Name','gif animation');
% pos = get(gcf,'position');
% dpi = get(0,'ScreenSize');
% set(gcf,'position',[(dpi(3)-pos(3))/2,(dpi(4)-pos(4))/2,pos(3),pos(4)]);

aviName = ['[\tau_1=',num2str(tau1),' \tau_2=',num2str(tau2),' l_1=',num2str(l1),' l_2=',num2str(l2),']'];
aviObj = VideoWriter(['t1=',num2str(tau1),' t2=',num2str(tau2),' l1=',num2str(l1),' l2=',num2str(l2),'.avi']);
aviObj.FrameRate = round(length(odet)/odet(end)); % 为保证动画时长与实际相同，帧率等于帧数除以时长
aniMechan(aviObj,[aviName,' '], ...
    odet,rA,rB,rC,rD,rE,rF,rG);

%% 作图
f2 = figure('Name','joint angle');
t2 = tiledlayout(3,1);
nexttile;
plot(odet,q(:,1),'LineWidth',1); hold on;
plot(odet,q(:,2),'LineWidth',1);
plot(odet,q(:,1)+q(:,2),'LineStyle','-');
ylabel('\theta(rad)');
grid on;

nexttile;
plot(odet,qd(:,1),'LineWidth',1); hold on;
plot(odet,qd(:,2),'LineWidth',1);
plot(odet,qd(:,1)+qd(:,2),'LineStyle','-');
ylabel('$\dot{\theta}(rad/s)$','Interpreter','latex');
grid on;

nexttile;
plot(odet,qdd(:,1),'LineWidth',1); hold on;
plot(odet,qdd(:,2),'LineWidth',1);
plot(odet,qdd(:,1)+qdd(:,2),'LineStyle','-');
grid on;
ylabel('$\ddot{\theta}(rad/s^2)$','Interpreter','latex');
xlabel('t(s)');
title(t2,'Angular Kinematics Results', aviName);
legend('\theta_1','\theta_2','\theta_1+\theta_2','Orientation','horizontal',...
    'Location','southoutside');

% E position
f3 = figure('Name','E position');
t3 = tiledlayout(3,1);
nexttile;
plot(odet,rE); hold on;
ylabel('r_E(m)');
grid on;

nexttile;
plot(odet,rE_d); hold on;
ylabel('$\dot{r}_E(m/s)$','Interpreter','latex');
grid on;

nexttile;
plot(odet,rE_dd); hold on;
grid on;
ylabel('$\ddot{r}_E(m/s^2)$','Interpreter','latex');
xlabel('t(s)');
title(t3,'Kinematics Results at Point E');
legend('x_E','y_E','Orientation','horizontal',...
    'Location','southoutside');

f4 = figure('Name','F position');
t4 = tiledlayout(3,1);
nexttile;
plot(odet,rF); hold on;
ylabel('r_F(m)');
grid on;

nexttile;
plot(odet,rF_d); hold on;
ylabel('$\dot{r}_F(m/s)$','Interpreter','latex');
grid on;

nexttile;
plot(odet,rF_dd); hold on;
grid on;
ylabel('$\ddot{r}_F(m/s^2)$','Interpreter','latex');
xlabel('t(s)');
title(t4,'Kinematics Results at Point F');
legend('x_F','y_F','Orientation','horizontal',...
    'Location','southoutside');

rmpath(genpath('funcs'));