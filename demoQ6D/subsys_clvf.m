close all
clear 
clc

%% Should we compute the trajectory?
compTraj = true;

%% Grid
grid_min = [-5; -5; -35*pi/180; -1]; % Lower corner of computation domain
grid_max = [5;  5;  35*pi/180; 1];   % Upper corner of computation domain
N = [101 101 ceil(101/8) ceil(101/5)];         % Number of grid points per dimension
%pdDims = 3;               % 3rd dimension is periodic
g = createGrid(grid_min, grid_max, N);

%% time vector

t0 = 0;
tMax = 50;
dt = 0.05;
tau = t0:dt:tMax;

%% problem parameters

% control trying to min or max value function?
uMode = 'min';

%% Pack problem parameters
params.u_max = 20/180*pi; % maximum control input
params.u_min  = -20/180*pi; % minimum control input 

uRange = [params.u_min, params.u_max];
quadcopter = q8Dsys1([0, 0, 0], uRange);

gamma1 = 0;
gamma2 = 0.3;
gamma3 = 3;

%% target set
R = 0;
%data0 = shapeCylinder(g, 3, [0,0,0], R);
data0 = shapeRectangleByCorners(g,[0,0,0,0],[0,0,0,0]);
% Put grid and dynamic systems into schemeData
schemeData.grid = g;
schemeData.dynSys = quadcopter;
schemeData.accuracy = 'high'; %set accuracy
schemeData.uMode = uMode;



%% Compute value function

[data1,tau1] = ComputeHJ(data0,tau,schemeData,1,gamma1);
% [data2,tau2] = ComputeHJ(data00,tau,schemeData,2,gamma2);
% [data3,tau3] = ComputeHJ(data0,tau,schemeData,3,gamma3);
% % [data4,tau4] = ComputeHJ(data01,tau,schemeData,4,gamma3);
% 

% Save the value function and grid 
save('data_subsys.mat','data1')
save('g_subsys.mat','g')


%%
function [data,tau] = ComputeHJ(data0,tau0,schemeData,n,gamma)

HJIextraArgs.visualize.valueSet = 1;
HJIextraArgs.visualize.valueFunction = 1;
HJIextraArgs.visualize.initialValueSet = 1;
HJIextraArgs.visualize.figNum = n; %set figure number
HJIextraArgs.visualize.deleteLastPlot = true; %delete previous plot as you update
HJIextraArgs.targetFunction = data0;
HJIextraArgs.convergeThreshold = 0.1;
HJIextraArgs.stopConverge = 1;
%HJIextraArgs.divergeThreshold = 0.8;
%HJIextraArgs.stopDiverge = 1;
HJIextraArgs.keepLast = 1;
HJIextraArgs.makeVideo = 0;
HJIextraArgs.visualize.plotData.plotDims = [1 1 0 0]; %plot x, v
HJIextraArgs.visualize.plotData.projpt = 'min'; %project at theta = 0
HJIextraArgs.visualize.viewAngle = [30,-10]; % view 2D
HJIextraArgs.visualize.viewAxis = [-5 5 -5 5 0 5];
HJIextraArgs.ignoreBoundary = 1;
schemeData.clf.gamma = gamma;
HJIextraArgs.visualize.xTitle = "x1";
HJIextraArgs.visualize.yTitle = "x2";


[data, tau, ~] = ...
  HJIPDE_ZGsolve(data0, tau0, schemeData, 'minCLF', HJIextraArgs);

end
