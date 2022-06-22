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

tau1 = 0.05;
tau2 = 0.05;

%% matlab genetic algorithm function
l1 = 0.05; % begin with the original parameters
l2 = 0.025;


x  = ga(@fun,2);


%% 
function te = fun(l)
tau1 = 0.05;
tau2 = 0.05;
tspan = [0 500];
q0 = [0;0;0;0];
odeOpt = odeset('RelTol',1e-3,'AbsTol',1e-5,'InitialStep',0.001, ...
    'Events',@(t,y)isEnd(t,y,l(1),l(2)));
[~,~,te,~,~] = ode45(@(t,y)newtonEuler(t,y,l(1),l(2),tau1,tau2), tspan, q0, odeOpt);
te = -te;

end

%% 