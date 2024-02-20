close all
clear 
clc

%% Should we compute the trajectory?
compTraj = true;

%% Grid
grid_min = [-2; -2; -35*pi/180; -2; -2; -35*pi/180]; % Lower corner of computation domain
grid_max = [2; 2; 35*pi/180; 2; 2; 35*pi/180];    % Upper corner of computation domain
N = [21, 21, 21, 21, 21, 21];         % Number of grid points per dimension
pdDims = [3,6];               % 3rd dimension is periodic
g = createGrid(grid_min, grid_max, N, pdDims);

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
params.u_max = [10/180*pi;10/180*pi]; % maximum control input
params.u_min  = [-10/180*pi;-10/180*pi]; % minimum control input 

%obj = Cart1D(x, uMin, uMax)
uRange = {params.u_min; params.u_max};
quadcopter = q6D([0, 0, 0, 0, 0, 0], uRange);

gamma1 = 0;
gamma2 = 0.3;
gamma3 = 3;

%% target set
R = 0;
data0 = shapeCylinder(g, [2,3,5,6], [0,0,0,0,0,0], R);

% Put grid and dynamic systems into schemeData
schemeData.grid = g;
schemeData.dynSys = quadcopter;
schemeData.accuracy = 'veryHigh'; %set accuracy
schemeData.uMode = uMode;
schemeData.dMode = dMode;



%% Compute value function

[data1,tau1] = ComputeHJ(data0,tau,schemeData,1,gamma1);
% [data2,tau2] = ComputeHJ(data00,tau,schemeData,2,gamma2);
% [data3,tau3] = ComputeHJ(data0,tau,schemeData,3,gamma3);
% % [data4,tau4] = ComputeHJ(data01,tau,schemeData,4,gamma3);
% 

% Save the value function and grid 
save('demoQ6D/data_full.mat','data1')
save('demoQ6D/g_full.mat','g')


%%
function [data,tau] = ComputeHJ(data0,tau0,schemeData,n,gamma)

HJIextraArgs.visualize.valueSet = 1;
HJIextraArgs.visualize.valueFunction = 1;
HJIextraArgs.visualize.initialValueSet = 1;
HJIextraArgs.visualize.figNum = n; %set figure number
HJIextraArgs.visualize.deleteLastPlot = true; %delete previous plot as you update
HJIextraArgs.targetFunction = data0;
HJIextraArgs.convergeThreshold = 0.01;
HJIextraArgs.stopConverge = 1;
HJIextraArgs.keepLast = 1;
HJIextraArgs.makeVideo = 0;
HJIextraArgs.visualize.plotData.plotDims = [1 0 0 1 0 0]; %plot x, y
HJIextraArgs.visualize.plotData.projpt = [0 0 0 0]; %project at theta = 0
HJIextraArgs.visualize.viewAngle = [30,-10]; % view 2D
HJIextraArgs.visualize.viewAxis = [-1.5 1.5 -1.5 1.5 -pi pi];
HJIextraArgs.ignoreBoundary = 1;
schemeData.clf.gamma = gamma;


[data, tau, ~] = ...
  HJIPDE_ZGsolve(data0, tau0, schemeData, 'minCLF', HJIextraArgs);

end
