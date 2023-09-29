function [f,P,input_issue] = fuel_model_Compact_simplified(v,a,g,flag_project)
%FUEL_MODEL_COMPACT_SIMPLIFIED
%   Version 1.0
%   (C) 2023/09/30 by CIRCLES project energy team
%    Nour Khoudari, Sulaiman Almatrudi, Rabie Ramadan,
%    Joy Carpio, Mengsha Yao, Kenneth Butts, Alexandre M. Bayen,
%    Jonathan W. Lee, and Benjamin Seibold.

%   Simplified fuel consumption rate model for vehicle:
%   Compact Sedan, a small sedan of mass 1543 kg.
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
f_idle =0.0972;
b1 = 3.3605;
b2 = 41.6037;
b3 =  0.00021189;
b4 =  8.9362;
b5 = 3.9757;
b6 = 0.24476;
c0 = 0.15918;
c1 = 0.013463;
c2 = 0;
c3 = 3.1889e-05;
p0 = 0.047828;
p1 = 0.086975;
p2 = 6.825e-08;
q0 = 0.0025557;
q1 = 0.019099;
z0 = 0.13285;
z1 = 0.77984;
z2 = 0.0019733;
vc = 5.04;
beta0 = 0.0972;
a0 = -0.26981;
a1 = -0.0023996;
a2 = -9.0623;
a3 = -0.00029215;
a4 = -0.011899;
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

f_min = (v<=vc)*beta0;                  % minimum possible f (fuel cut vel. vc)
f = max(f,f_min);                       % cap fitted f from below
a_brake = a0 + a1.*v + a2.*g +...
          a3.*v.^2 + a4*v.*g;           % acceleration at fuel cut
f (v>vc & a<=a_brake)=0; 

f(v<.1&abs(a)<.01) = f_idle;            % set f to idle for v<.1m/s&|a|<.01m/s^2

P = f*gs2kW;                            % calculate equivalent power

