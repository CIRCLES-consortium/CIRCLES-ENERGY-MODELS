function [f,P,input_issue] = fuel_model_Class8Tractor_simplified(v,a,g,flag_project)
%FUEL_MODEL_CLASS8TRACTOR_SIMPLIFIED
%   Version 1.0
%   (C) 2023/09/30 by CIRCLES project energy team
%    Nour Khoudari, Sulaiman Almatrudi, Rabie Ramadan,
%    Joy Carpio, Mengsha Yao, Kenneth Butts, Alexandre M. Bayen,
%    Jonathan W. Lee, and Benjamin Seibold.

%   Simplified fuel consumption rate model for vehicle:
%   Class8Tractor, a truck with manual transmission and a trailer and total mass 25104 kg.
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
% Vehicle-specific model parameters
%========================================================================
f_idle =0.2384;
b1 = 2.4229;
b2 = 8.4463;
b3 =  0.00026269;
b4 =  9.7395;
b5 = 8.6171;
b6 = 0.15762;
c0 = 0.59448;
c1 = 0.082609;
c2 = 0;
c3 = 0.00027278;
p0 = 0.20476;
p1 = 1.1962;
p2 = 0.019119;
q0 = 0;
q1 = 0.14424;
z0 = 0.88147;
z1 = 11.1899;
z2 = 0.18836;
h0 = 0.49109;
h1 = 0.025152;
%========================================================================
% Other constants
%========================================================================
gs2kW =  42.47;                         % grams/sec to kW conversion factor (diesel)
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
% Evaluate model
%========================================================================
% boundary of fitted feasibility region
ma = min(b1,b2./max(v,1e-12)-b3*max(v,0).^2) - min(b4,b5+b6.*max(v,0)).*g; 
input_issue = zeros(size(v));            % initialize flag with zeros
input_issue = input_issue + 2*(v<0) +... % assign 2 where v<0,
              (v>=0).*(a>ma);            % and 1 where v>=0 but input infeasible
           
if flag_project, a = min(a,ma); end      % projection of infeasible accel to max feasible accel
v = max(v,0);                            % treat negative velocities as zero 

% acceleration at which q(v) is min
aplus = max(a,-(p0 + p1*v +p2*v.^2)./(2*(q0 + q1.*max(v,1e-12))));

% Evaluate piecewise polyomial fuel consumption rate formula 
f = c0 + c1*v + c2*v.^2 + c3*v.^3 +...  % cruising terms
    p0*a + p1*a.*v + p2*a.*v.^2 +...    % linear acceleration terms
    q0*aplus.^2 + q1*aplus.^2.*v +...   % quadratic acceleration terms
    z0*g + z1*g.*v + z2*g.*v.^2;        % road grade terms

H = h0 + h1*v;                          % minimum possible fitted f
f = max(f,H);                           % cap fitted f from below

f(v<.1&abs(a)<.01) = f_idle;            % set f to idle for v<.1m/s&|a|<.01m/s^2

P = f*gs2kW;                            % calculate equivalent power

