% to solve how the torque influences the swinging time
clear;
clc;
addpath(genpath('funcs'));

%% parameter
L0 = 0.5;
L1 = 0.15;
L2 = 0.1;
m1 = 0.6;
m2 = 0.5;
J1 = m1*L1^2/12;
J2 = m2*L2^2/12;
l1 = 0.1;
l2 = 0.075;

tspan = [0 50];
q0 = [0;0;0;0];

%% traverse the torque in possible ranges
tau1 = 0:0.002:0.1;
tau2 = 0:0.002:0.1;
n1 = length(tau1);
n2 = length(tau2);
n = n1*n2;
endTime = zeros(n2,n1);
odeOpt = odeset('RelTol',1e-6,'AbsTol',1e-8,'InitialStep',0.001, ...
    'Events',@(t,y)isEnd(t,y,l1,l2));

tic
% p = parpool(6); % parallel computing for the for-loop
parfor ii = 1:n1
    for jj = 1:n2
        [~,~,te,~,~] = ode45(...
            @(t,y)newtonEuler(t,y,l1,l2,tau1(ii),tau2(jj)), tspan, q0, odeOpt);
        if isempty(te)
            endTime(jj,ii) = tspan(2);
        else
            endTime(jj,ii) = te;
        end
    end
end
% delete(p);
toc

%% plot the result of the 2-D search
figure('Name','torque traverse');
surf(tau1,tau2,endTime,'FaceColor','interp','EdgeColor','none'); % endTime has l1 cols and l2 rows
% shading interp
hold on;
xlabel('\tau_1(N \cdot m/(rad/s))');
ylabel('\tau_2(N \cdot m/(rad/s))');
zlabel('end time(s)');
title(['Result of traversing the torque [l1=',num2str(l1),' l2=',num2str(l2),']']);
colorbar;

% h2 = axes('Position',[0.55 0.25 0.17 0.17]);
h2 = axes('Position',[0.50 0.60 0.25 0.25]);
plot(tau1,mean(endTime)); hold on;
grid on;
% surf(tau1,tau2,endTime,'FaceColor','interp','EdgeColor','none');
% set(h2,'TickDir','none');
set(h2,'XTick',[0,0.025,0.05,0.075,0.1],'xticklabel',[0,.025,.05,.075,.1]);
% set(h2,'YTick',[0,500,1000,1500,2000],'yticklabel',[]);


%%





%%
rmpath(genpath('funcs'));