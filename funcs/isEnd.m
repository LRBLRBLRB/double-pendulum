function [value,isterminal,direction] = isEnd(t,y,l1,l2)
L0 = 0.5;
L1 = 0.15;
L2 = 0.1;
m1 = 0.6;
m2 = 0.5;
J1 = m1*L1^2/12;
J2 = m2*L2^2/12;

g = 9.8;

% 求解系统当前时刻机械能
v1 = ((L1/2 - l1)*y(3))^2;
v2 = (l1*sin(y(1))*y(3) - (L2/2 - l2)*sin(y(1)+y(2))*(y(3)+y(4)))^2 ...
   +(-l1*cos(y(1))*y(3) + (L2/2 - l2)*cos(y(1)+y(2))*(y(3)+y(4)))^2;

E = m1*g*(L0 + (L1/2 - l1)*sin(y(1))) ...
  + m2*g*(L0 - l1*sin(y(1)) + (L2/2 - l2)*sin(y(1)+y(2))) ...
  + 0.5*m1*v1 + 0.5*J1*(y(3)^2) ...
  + 0.5*m2*v2 + 0.5*J2*(y(3)+y(4))^2;

% 判断迭代是否终止
E0 = getEndEner(l1,l2);
value = (E - E0) > 0;
isterminal = 1; % 意味着积分在value发生时终止
direction = []; % 意味着必须是value从正数减小为0时迭代终止

end