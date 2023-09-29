function plot_semiprincipled_vs_simplified_model_on_drivecycles(VehicleName,DrivecycleName,grade)
%PLOT_SEMIPRICIPLED_VS_SIMPLIFIED_MODEL_ON_DRIVECYCLES
% function that loads the saved semi-principled model evaluations and
% plots the interpolation of the semi-principled model vs simplified model
% instaneous fuel consumption rate for the specified drivecycle, 
% road grade, and vehicle class.
%
% Inputs:
% VehicleName = choose from 'midSUV', 'Compact', 'midBase', 'Pickup'
%               'Class4PND', 'Class8Tractor'.
% Drivecycle = choose from 'UDDS', 'HWFET', 'US06', 'WLTC',
%               'Cruise', 'Transient', 'High', 'H65'.
% grade = road grade (in radians), the value that will be assumed constant 
%         drivecycle on the whole.
%         

if nargin<3, grade = 0; end % if no grade specified, assume flat road
if nargin<2, error('Specify EPA drivecycle.');end
if nargin<1, error('Specify vehicle class.');end

% load the drivecycle speeds
D = readtable([DrivecycleName '_drivecycle_speeds_10Hz.csv']);
D_v = table2array(D(:,1));
D_t = 0:0.1:0.1*(size(D_v)-1); D_t = D_t';
D_a = (D_v([2:end,end])-D_v([1,1:end-1]))./(D_t([2:end,end])-D_t([1,1:end-1]));

% interpolate the semi-principled model at the given drivecycle
eval(sprintf(['[F_semiprincipled_interpolated,~,~] = fuel_model_'...
        VehicleName '_semiprincipled(D_v,D_a,grade+D_v*0,true);']))

% evaluate the simplified model at the given drivecycle
eval(sprintf(['[F_simplified,~,~] = fuel_model_'...
        VehicleName '_simplified(D_v,D_a,grade+D_v*0,true);']))
       
% plot the interpolated semi-principled values vs the simplified model
figure;
plot(D_t,F_semiprincipled_interpolated,'r-',D_t,F_simplified,'b-')
xlabel('time (s)')
ylabel('fuel rate (g/s)')
legend('Interpolated Semiprincipled model','Simplified model')
title(sprintf('Models of %s on %s drivecycle with %0.2f road grade', VehicleName, DrivecycleName, grade));


