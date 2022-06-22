% solve the mechanism energy at the end of the iteration
function E0 = getEndEner(l1,l2)
L0 = 0.5;
L1 = 0.15;
L2 = 0.1;
m1 = 0.6;
m2 = 0.5;

g = 9.8;
% 求解系统最大和最小机械能
EMin1 = m1*g*(L0 - L1/2 + l1) + m2*g*(L0 + l1 - abs(L2/2 - l2));
EMin2 = m1*g*(L0 + L1/2 - l1) + m2*g*(L0 - l1 - abs(L2/2 - l2));
EMax = (m1 + m2)*g*L0;
EMin = min([EMin1 EMin2]);

% 判断终止的条件：机械能变为最小值的1.001
% E0 = 1.001*EMin;
E0 = EMin + 0.005*(EMax - EMin);

end