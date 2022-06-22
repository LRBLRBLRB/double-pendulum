% 带广义坐标的牛顿-欧拉运动微分方程求解
function [dydt,rD,rE,rF,rG,rE_d,rF_d,rE_dd,rF_dd] = newtonEuler(t,y,l1,l2,tau1,tau2)
L0 = 0.5;
L1 = 0.15;
L2 = 0.1;
m1 = 0.6;
m2 = 0.5;
J1 = m1*L1^2/12;
J2 = m2*L2^2/12;

g = 9.8;
II = [0, -1; 1, 0];
ex = [1; 0];

q = y(1:2,:);
qd = y(3:4,:);

R1 = [cos(q(1)), -sin(q(1)); sin(q(1)), cos(q(1))];
R2 = [cos(q(1)+q(2)), -sin(q(1)+q(2)); sin(q(1)+q(2)), cos(q(1)+q(2))];
rC = [0;L0];
rD = rC - l1*R1*ex;
rE = rC + (L1 - l1)*R1*ex;
rF = rD + (L2 - l2)*R2*ex;
rG = rD - l2*R2*ex;
% s1 = (rD + rE)/2;
% s2 = (rF + rG)/2;

J = [(L1/2 - l1)*II*R1*ex,               zeros(2, 1);...
     1,                                  0;...
     (L2/2 - l2)*II*R2*ex - l1*II*R1*ex, (L2/2 - l2)*II*R2*ex;...
     1,                                  1];

C = [-(L1/2-l1)*R1*ex*(qd(1)^2);...
    0;...
    l1*R1*ex*(qd(1)^2) - (L2/2-l2)*R2*ex*(qd(1)+qd(2))^2;...
    0];

Phi = diag([m1, m1, J1, m2, m2, J2]);

F = [0; -m1*g; tau2*qd(2)-tau1*qd(1); 0; -m2*g; -tau2*qd(2)];

qdd = (J'*Phi*J)\(J'*(F - Phi*C));

rD_d = -l1*II*R1*ex*qd(1);
rE_d = (L1 - l1)*II*R1*ex*qd(1);
rF_d = rD_d + (L2 - l2)*II*R2*ex*(qd(1)+qd(2));
% s1_d = 1/2*(rD_d + rE_d);
% s2_d = rD_d + (L2/2 - l2)*II*R2*ex*qd(2);

rD_dd = -l1*II*R1*ex*qdd(1) + l1*R1*ex*(qd(1))^2;
rE_dd = (L1 - l1)*II*R1*ex*qdd(1) - (L1 - l1)*R1*ex*(qd(1))^2;
rF_dd = rD_dd + (L2 - l2)*II*R2*ex*(qdd(1)+qdd(2)) - (L2 - l2)*R2*ex*(qd(1)+qd(2))^2;

dydt(1:2,:) = qd;
dydt(3:4,:) = qdd;

% E = 0.5*qd'*J'*Phi*J*qd + m1*g*s1(2) + m2*g*s2(2);

end