% Create all symbols
syms R1 R2 C1 C2 C3 C4 w positive
syms Vi Vcm Vo s Voff;

% Individual capacitor impedances
ZC1 = 1/(s*C1);
ZC2 = 1/(s*C2);
ZC3 = 1/(s*C3);
ZC4 = 1/(s*C4);

% Impedances as in the circuit
Z1 = R1*ZC1 / (R1 + ZC1);
Z2 = R2*ZC2 / (R2 + ZC2);
Z3 = ZC3;
Z4 = ZC4;

% Positive and negative inputs
Vip = Vcm + Vi/2;
Vin = Vcm - Vi/2;

% OPAMP input terminal voltages
Vp = (Vip * Z1 / (Z1 + Z3));
Vn = (Vin * Z2 + Vo * Z4) / (Z2 + Z4);
Vp = collect(Vp,s);
Vn = collect(Vn,s);

% Solve for Vo
Vo = solve(Vp - Vn, Vo);
Vo = collect(Vo, s);

% Fragments of Vo
Vo_n   = collect(subs(subs(Vo, Vcm, 0), Vi, 0), s); % Natural response
Vo_Vi  = collect(subs(Vo-Vo_n, Vcm, 0)/Vi, s); % Vo/Vi
Vo_Vcm = collect(subs(Vo-Vo_n, Vi, 0)/Vcm, s); % Vo/Vcm


% Simplified version of the transfer function:
Vo_Vi_s = collect(subs(Vo_Vi,[R2,C2,C4],[R1,C1,C3]),s);

%return

% disp('Vo = ');
% pretty(Vo);

% Change to fourrier analysis
Vo = subs(Vo, s, i*w);
Vo = collect(Vo, w);

% Find transfer function Vo/Vi when Vcm=0
G = subs(Vo, Vcm, 0) / Vi;
G = collect(G, w);

% Break numerator and denominator apart
[N,D] = numden(G);
N = collect(N,w);
D = collect(D,w);

Re_N = collect(subs(N,i,0),w);
Im_N = collect(subs(collect(-i*N,w),i,0),w);
Re_D = collect(subs(D,i,0),w);
Im_D = collect(subs(collect(-i*D,w),i,0),w);

Gain = sqrt(Re_N^2 + Im_N^2) / sqrt(Re_D^2 + Im_D^2);
Gain = collect(Gain, w);
% pretty(Gain)
w0 = simplify(solve(simplify(Gain^2) - 1/2, w));

% Use gain-squared w-cefficients to get sensittivity when w->infinity
G2 = collect(simplify(Gain^2),w);
[G2N, G2D] = numden(G2);
G2N_coeffs = simplify(coeffs(G2N, w, 'all'));
G2D_coeffs = simplify(coeffs(G2D, w, 'all'));

if length(G2N_coeffs) ~= length(G2D_coeffs)
  disp('Error, G2N and G2D have different powers of w.')
  return
end

% This is wall we need for sensitivity:
G2SF = simplify(G2N_coeffs(1) / simplify(G2D_coeffs(1)));

% R1 = 220e3;
% R2 = 220e3;
% C1 = 270e-9;
% C2 = 270e-9;
% C3 = 1e-9;
% C4 = 1e-9;

%Sensibilidade para C1:
derivadaC1 = diff(G2SF,'C1');
SensC1 = simplify((C1/G2SF)*derivadaC1);


%Sensibilidade para C2:
derivadaC2 = diff(G2SF,'C2');
SensC2 = simplify((C2/G2SF)*derivadaC2);

%Sensibilidade para C3:
derivadaC3 = diff(G2SF,'C3');
SensC3 = simplify((C3/G2SF)*derivadaC3);

%Sensibilidade para C4:
derivadaC4 = diff(G2SF,'C4');
SensC4 = simplify((C4/G2SF)*derivadaC4);

% Try a specific setting
% w0t = w0;
% w0t = subs(w0t, R2, R1);
% w0t = subs(w0t, C2, C1);
% w0t = subs(w0t, C4, C3);
% pretty(simplify(w0t))
