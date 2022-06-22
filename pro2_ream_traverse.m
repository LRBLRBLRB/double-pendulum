% traverse all the possible C and D positions to get the longest swinging time
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
tau1 = 0.05;
tau2 = 0.05;

parCore = 7;

%% 简单二维搜索粗略估计杆长参数的最优区间
l1 = (L1*(0:0.01:1))'; % resolution: 0.0015
l2 = (L2*(0:0.01:1))'; % resolution: 0.0010

[endTimeInit,~] = lTrav(l1,l2,tau1,tau2,[0,500],parCore);

if exist("endTime","var")
    [endTmp,l2Ind] = max(endTimeInit);
    [~,l1Ind] = max(endTmp);
    l1MaxInit = l1(l1Ind);
    l2MaxInit = l2(l2Ind(l1Ind));
else
    l1MaxInit = 0.0405;
    l2MaxInit = 0.051;
end

%% plot the result of the 2-D search
figure;
pos = get(gcf,'position');
dpi = get(0,'ScreenSize');
set(gcf,'position',[(dpi(3)-2*pos(3))/2,(dpi(4)-pos(4))/2,2*pos(3),pos(4)]);
t1 = tiledlayout(1,2);
nexttile;
[l1Grid,l2Grid] = meshgrid(l1,l2);
surf(l1Grid,l2Grid,endTimeInit,'FaceColor','interp','EdgeColor','none');
% shading interp
hold on;
xlabel('l1(m)');
ylabel('l2(m)');
zlabel('end time(s)');

% contour for the traversing results
nexttile;
h2 = contourf(l1Grid,l2Grid,endTimeInit);
hold on;
xlabel('l1(m)');
ylabel('l2(m)');

title(t1,'Result of traversing the ream position');
cb = colorbar;
cb.Layout.Tile = 'east';

% detail view of the contour
h3 = axes('Position',[0.75,0.54,0.14,0.32]);
contourf(l1Grid,l2Grid,endTimeInit); hold on;
set(h3,'xtick',[],'xticklabel',[],'xlim',[l1MaxInit - 0.005, l1MaxInit + 0.005], ...
    'ytick',[],'yticklabel',[],'ylim',[l2MaxInit - 0.005, l2MaxInit + 0.005], ...
    'XColor','w','YColor','w');
annotation('rectangle',[0.51+(l1MaxInit-0.0025)/2/l1(end),(l2MaxInit-0.0025)/l2(end),0.006/l1(end),0.01/l2(end)],...
    'LineStyle','-','Color','w','LineWidth',1);


%% 精细搜索局部区域的最大值
l1Prec = (l1MaxInit - 0.0015):0.0001:(l1MaxInit + 0.0015);
l2Prec = (l2MaxInit - 0.0020):0.0001:(l2MaxInit + 0.0020);

[endTimePrec,~] = lTrav(l1Prec,l2Prec,tau1,tau2,[0 1000],parCore);
[endTmpPrec,l2IndPrec] = max(endTimePrec);
[~,l1IndPrec] = max(endTmpPrec);
l1MaxPrec = l1Prec(l1IndPrec);
% l2MaxPrec = l2Prec(l2IndPrec(l1IndPrec));
l2MaxPrec = l2MaxInit;

%% plot the result of the more precise 2-D search
figure;
pos = get(gcf,'position');
dpi = get(0,'ScreenSize');
set(gcf,'position',[(dpi(3)-2*pos(3))/2,(dpi(4)-pos(4))/2,2*pos(3),pos(4)]);
t2 = tiledlayout(1,2);
nexttile;
[l1GridPrec,l2GridPrec] = meshgrid(l1Prec,l2Prec);
surf(l1GridPrec,l2GridPrec,endTimePrec,'FaceColor','interp','EdgeColor','none');
% shading interp
hold on;
xlabel('l1(m)');
ylabel('l2(m)');
zlabel('end time(s)');

% contour for the traversing results
nexttile;
h5 = contourf(l1GridPrec,l2GridPrec,endTimePrec);
hold on;
xlabel('l1(m)');
ylabel('l2(m)');

title(t2,'Result of traversing the ream position with higher accuracy');
cb = colorbar;
cb.Layout.Tile = 'east';

% detail view of the contour
% h6 = axes('Position',[0.58,0.54,0.14,0.32]);
% contourf(l1GridPrec,l2GridPrec,endTimePrec); hold on;
% set(h6,'xtick',[],'xticklabel',[],'xlim',[l1MaxPrec - 0.0005, l1MaxPrec + 0.0005], ...
%     'ytick',[],'yticklabel',[],'ylim',[l2MaxPrec - 0.0010, l2MaxPrec + 0.0010], ...
%     'XColor','w','YColor','w');
% annotation('rectangle',[0.51+(l1MaxPrec-0.00025)/2/l1Prec(end),(l2MaxPrec-0.00025)/l2Prec(end),...
%     0.006/l1Prec(end),0.01/l2Prec(end)],'LineStyle','-','Color','w','LineWidth',1);

%% animate the longest time situation
figure('Name','gif animation');

tspan = [0 2000];
q0 = [0;0;0;0];
odeOpt = odeset('RelTol',1e-3,'AbsTol',1e-5,'InitialStep',0.001, ...
    'Events',@(t,y)isEnd(t,y,l1MaxPrec,l2MaxPrec));
[odet,odey,te,ye,ie] = ode45(@(t,y)newtonEuler(t,y,l1MaxPrec,l2MaxPrec,tau1,tau2), tspan, q0, odeOpt);
[~,rD,rE,rF,rG,~,~,~,~] = cellfun(@(t,y) newtonEuler(t,y.',l1MaxPrec,l2MaxPrec,tau1,tau2), ...
    num2cell(odet), num2cell(odey,2), 'uni', 0);
% q = odey(:,1:2);
% qd = odey(:,3:4);
% qdd = transpose(cell2mat(odeyd'));
% qdd = qdd(:,3:4);
rA = [-L0*0.6; 0];
rB = [L0*0.6; 0];
rC = [0; L0];
rD = transpose(cell2mat(rD'));
rE = transpose(cell2mat(rE'));
rF = transpose(cell2mat(rF'));
rG = transpose(cell2mat(rG'));

videoTitle = "traverseBy16.avi";
aviObj = VideoWriter(videoTitle);
aviObj.FrameRate = round(length(odet)/odet(end));

% ii = find(odet>30,1);
spe = 100;
aniMechan(aviObj,['[l_1=',num2str(l1MaxPrec),'l_2=',num2str(l2MaxPrec),'] '],odet(1:spe:end,:),rA,rB,rC,rD(1:spe:end,:),rE(1:spe:end,:),rF(1:spe:end,:),rG(1:spe:end,:));



%%
rmpath(genpath('funcs'));

%% traverse all the ream length and return a matrix of end time
function [endTime,tPlay] = lTrav(l1,l2,tau1,tau2,tspan,parCore)
n1 = length(l1);
n2 = length(l2);
endTime = zeros(n2,n1);

q0 = [0;0;0;0];
odeOpt1 = odeset('RelTol',1e-3,'AbsTol',1e-5,'InitialStep',0.001);

tic
p = parpool(parCore); % parallel computing for the for-loop
parfor ii = 1:n1
    for jj = 1:n2
        odeOpt2 = odeset('Events',@(t,y)isEnd(t,y,l1(ii),l2(jj)));
        odeOpt = odeset(odeOpt1,odeOpt2);
        [~,~,te,~,~] = ode45(@(t,y)newtonEuler(t,y,l1(ii),l2(jj),tau1,tau2), tspan, q0, odeOpt);
        if isempty(te)
            endTime(jj,ii) = tspan(2);
        else
            endTime(jj,ii) = te;
        end
    end
end
delete(p);

tPlay = toc

end