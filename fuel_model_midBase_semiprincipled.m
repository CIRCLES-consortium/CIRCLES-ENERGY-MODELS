function [f,P,input_issue] = fuel_model_midBase_semiprincipled(v,a,g,flag_project)
%FUEL_MODEL_MIDBASE_SEMIPRINCIPLED
%   Version 1.0
%   (C) 2023/09/30 by CIRCLES project energy team
%    Nour Khoudari, Sulaiman Almatrudi, Rabie Ramadan,
%    Joy Carpio, Mengsha Yao, Kenneth Butts, Alexandre M. Bayen,
%    Jonathan W. Lee, and Benjamin Seibold.

%   Semi-principled fuel consumption rate model for vehicle:
%   Midsize Sedan, a mid size compact sedan with mass 1743 kg.
%   The function outputs the instaneous fuel consumption rate (and
%   equivalent power and feasibility state), given instaneous velocity,
%   acceleration, and road grade.
%   Inputs may be given as vectors or matrices, resulting in outputs of
%   the same size.

%   Inputs:
%   v = vehicle velocity (in m/s)
%   a = vehicle acceleration (in m/s^2)
%   g = road grade (in radians)
%       [Note: a 3% downhill slope is to be inputted as g = atan(-0.03);
%       however, for any realistic slopes, the atan can be omitted]
%   flag_project = boolean, prescribing whether infeasible (f,a,g) inputs
%                  get projected to the boundary of the feasible domain

%   Outputs:
%   f = fuel consumption rate (in grams/sec)
%   P = equivalent power (in KW)
%   input_issue = 0 if no warning
%   input_issue = 1 if input infeasible (impossible to realize by the vehicle),
%   input_issue = 2 if velocity negative
%   [Note: The model extends gracefully outside of its feasibility
%   region: negative velocities are treated like zero; and non-realizable
%   (v,a,g)-requests are assigned f and P values that simply extrapolate
%   the fitted polynomials if flag_project = false.
%========================================================================
% Read Evaluation Tables
%========================================================================
% load the saved semi-principled model evaluations
T = readtable('midBase_semiprincipled_model_evaluations.csv');
V = T.Velocity;
A = T.Acceleration;
G = T.RoadGrade;
F = T.FuelRate;
I = T.Infeasible;
vv = unique(V); aa = unique(A); gg = unique(G);

FF = reshape(F, [length(gg) length(aa) length(vv)]);
II = reshape(I, [length(gg) length(aa) length(vv)]);
AA = reshape(A, [length(gg) length(aa) length(vv)]);
VV = reshape(V, [length(gg) length(aa) length(vv)]);
GG = reshape(G, [length(gg) length(aa) length(vv)]);

%========================================================================
% Other constants
%========================================================================
gs2kW = 42.36;                          % grams/sec to kW conversion factor (gasoline)
%========================================================================
% Checks of inputs
%========================================================================
if nargin<4, flag_project = true; end   % default is to use projection
if nargin<3, g = v*0; end               % if no grade specified, assume flat road
if nargin<2, a = v*0; end               % if no acceleration is specified, assume cruising
if length(a)==1, a = a*ones(size(v)); end
if length(g)==1, g = g*ones(size(v)); end
if ~all(size(v)==size(a)&size(a)==size(g))
     error('Inputs must be of identical size.')
end
%========================================================================
% Interpolate model
%========================================================================
input_issue = interp3(AA,GG,VV,II,a,g,v);% interpolate infeasibility flags
input_issue = 0.*(input_issue==0).*(v>=0) +...   
              1.*(input_issue~=0).*(v>=0) + ...
              2.*(v<0);                  % set input_issue to 0, 1, or 2
          
v = max(v,0);                            % treat negative velocities as zero 

% interpolated boundary of feasibility region 
MA = zeros(size(AA));
I_mask = (II == 0);
for i = 1:size(AA, 1)
    for j = 1:size(AA, 3)
        MA(i, :, j) = max(AA(i, :, j) .* I_mask(i, :, j), [], 2);
    end
end

ma = interp3(AA,GG,VV,MA,-3+0*v,g,v);
        
if flag_project, a = min(a,ma); end      % projection of infeasible accel to max feasible accel

% Interpolate fuel consumption rate 
f = interp3(AA,GG,VV,FF,a,g,v);

P = f*gs2kW;                             % calculate equivalent power

