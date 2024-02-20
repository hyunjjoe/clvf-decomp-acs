close all
clear 
clc

%% Should we compute the trajectory?
compTraj = true;

%% Grid
grid_min = -2; % Lower corner of computation domain
grid_max = 2;    % Upper corner of computation domain
N = 201;         % Number of grid points per dimension
g = createGrid(grid_min, grid_max, N);
    
%% time vector
t0 = 0;
tMax = 50;
dt = 0.05;
tau = t0:dt:tMax;

%% problem parameters
% control trying to min or max value function?
uMode = 'min';
dMode = 'max';


%% Pack problem parameters
params.u_max = 1; % maximum control input
params.u_min  = -1; % minimum control input 

%obj = Cart1D(x, uMin, uMax)
uRange = [ params.u_min , params.u_max ];
dRange = {0,0};
sys2 = sys2d2(0, uRange, dRange, 1);

gamma1 = 0;
gamma2 = 0.1;
gamma3 = 3;

%% target set
R = 0;
data0 = shapeCylinder(g, [], [0; 0], R);
data0 = shapeRectangleByCorners(g, [0; 0], [0; 0]);

% Put grid and dynamic systems into schemeData
schemeData.grid = g;
schemeData.dynSys = sys2;
schemeData.accuracy = 'high'; %set accuracy
schemeData.uMode = uMode;
schemeData.dMode = dMode;



%% Compute value function
%disp(sys1)
[data1,tau1] = ComputeHJ(data0,tau,schemeData,1,gamma1);
% [data2,tau2] = ComputeHJ(data00,tau,schemeData,2,gamma2);
% [data3,tau3] = ComputeHJ(data0,tau,schemeData,3,gamma3);
% % [data4,tau4] = ComputeHJ(data01,tau,schemeData,4,gamma3);
%mind = min(data1,[],'all');
%data1 = data1 - mind;
% Save the value function and grid 
save('demo2D/data_sys2.mat','data1')
save('demo2D/g_sys2.mat','g')


%%
function [data,tau] = ComputeHJ(data0,tau0,schemeData,n,gamma)

HJIextraArgs.visualize.valueSet = 1;
HJIextraArgs.visualize.valueFunction = 1;
HJIextraArgs.visualize.initialValueSet = 1;
HJIextraArgs.visualize.figNum = n; %set figure number
HJIextraArgs.visualize.deleteLastPlot = true; %delete previous plot as you update
HJIextraArgs.targetFunction = data0;
HJIextraArgs.convergeThreshold = 2e-3;
HJIextraArgs.stopConverge = 1;
HJIextraArgs.keepLast = 1;
HJIextraArgs.ignoreBoundary = 1;
schemeData.clf.gamma = gamma;
HJIextraArgs.divergeThreshold = 8;
HJIextraArgs.stopDiverge = 1;


[data, tau, ~] = ...
  HJIPDE_ZGsolve(data0, tau0, schemeData, 'minCLF', HJIextraArgs);

end
