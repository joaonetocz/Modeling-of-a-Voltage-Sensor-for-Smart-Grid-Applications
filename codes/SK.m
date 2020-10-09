function T=SK(k)
C1 = k(1);
C2 = k(2);
C3 = k(3);
C4 = k(4);
R1 = k(5);
R2 = k(6);

s = tf('s');

% From Vi
T = ((C1*C4*R1*R2 + C2*C3*R1*R2 + 2*C3*C4*R1*R2)*s^2 + (C3*R1 + C4*R2)*s)/((2*C1*C2*R1*R2 + 2*C2*C3*R1*R2)*s^2 + (2*C1*R1 + 2*C2*R2 + 2*C3*R1)*s + 2);

% From Vcm
%T = ((C2*C3*R1*R2 - C1*C4*R1*R2)*s^2 + (C3*R1 - C4*R2)*s)/((C1*C2*R1*R2 + C2*C3*R1*R2)*s^2 + (C1*R1 + C2*R2 + C3*R1)*s + 1);
