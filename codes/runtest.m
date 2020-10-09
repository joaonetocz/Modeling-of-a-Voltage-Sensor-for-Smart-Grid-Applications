NPT  = 1000;
NTST = 100;
show_delta = 1; % Set to 0 or 1

f = logspace(-2, 6, NPT)';

w = 2*pi*f;
disp('Running simulations...');
tic();
nominal = [270e-9; 270e-9; 1e-9; 1e-9; 1e6; 1e6];
tolerance = [.05; 0.05; .05; .05; 0.01; 0.01];
[m,p] = monte(nominal, tolerance, w, @SK, NTST);
disp(sprintf('Completed in %fs.',toc()));

figure();
subplot(2,1,1);
% semilogx(f, 20*log10(m.all));
offset = - 20*log10(m.avg) * show_delta;
semilogx( ...
  f, 20*log10(m.avg) + offset, 'b-',  ...
  f, 20*log10(m.avg+m.dev) + offset, 'g-',  ...
  f, 20*log10(m.avg-m.dev) + offset, 'g-',  ...
  f, 20*log10(m.max) + offset, 'r-',  ...
  f, 20*log10(m.min) + offset, 'r-' ...
);
title('Gain (dB)');
grid

subplot(2,1,2);
%semilogx(w, p.all);
offset = - p.avg * show_delta;
semilogx( ...
  f, p.avg + offset, 'b-', ...
  f, p.avg+p.dev + offset, 'g-', ...
  f, p.avg-p.dev + offset, 'g-', ...
  f, p.max + offset, 'r-', ...
  f, p.min + offset, 'r-' ...
);
title('Phase(deg)');
xlabel('Frequency (Hz)');
grid;

% Ryzen 1700x at 16C*3.4GHz
%  ans =
%
%   Pool with properties:
%
%              Connected: true
%             NumWorkers: 16
%                Cluster: local
%          AttachedFiles: {}
%            IdleTimeout: 30 minute(s) (30 minutes remaining)
%            SpmdEnabled: true
%
%  >> runtest
%  Running simulations...
%  Completed in 13.377734s.
%  >> runtest
%  Running simulations...
%  Completed in 8.842193s.
%  >> runtest
%  Running simulations...
%  Completed in 8.820854s.
%  >>
