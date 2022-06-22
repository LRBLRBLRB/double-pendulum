close all;
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

%% matlab genetic algorithm function
l1 = 0.05; % begin with the original parameters
l2 = 0.025;
tau1 = 0.05;
tau2 = 0.05;

lb = [0;0];
ub = [L1;L2];
optimOpts = optimoptions('ga', ...
    'UseParallel',true, ...
    'PlotFcn',{@gaplotbestindiv, @gaplotbestf},...
    'MaxGenerations',50, ...
    'MaxStallGenerations',1, ...
    'FunctionTolerance',10);
[lMax,tMax] = ga(@(l) fun(l,[tau1;tau2]),2,[],[],[],[],lb,ub,[],optimOpts); 
% sometimes error无法执行赋值，因为左侧的大小为 1×1，右侧的大小为 0×0。
tMax = -tMax;

%% 
rmpath(genpath('funcs'));

%% 
function te = fun(l,tau)
tspan = [0 500];
q0 = [0;0;0;0];
odeOpt = odeset('RelTol',1e-3,'AbsTol',1e-5,'InitialStep',0.001, ...
    'Events',@(t,y)isEnd(t,y,l(1),l(2)));
[~,~,te,~,~] = ode45(@(t,y)newtonEuler(t,y,l(1),l(2),tau(1),tau(2)), tspan, q0, odeOpt);
te = -te; % ga: find the minimum value

end