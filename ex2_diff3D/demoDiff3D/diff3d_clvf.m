close all
clear 
clc

%% Should we compute the trajectory?
compTraj = true;

%% Grid
grid_min = [-2; -2; -2]; % Lower corner of computation domain
grid_max = [ 2; 2; 2];    % Upper corner of computation domain
N = [61; 61; 61];         % Number of grid points per dimension
g = createGrid(grid_min, grid_max, N);
    
%% time vector
t0 = 0;
tMax = 50;
dt = 0.1;
tau = t0:dt:tMax;

%% problem parameters
% control trying to min or max value function?
uMode = 'min';
 

%% Pack problem parameters
uRange = {[-1,1],[-1,1],[-0.5,0.5]};
sys = diff3d([0, 0, 0], uRange);

gamma1 = 0.1;
gamma2 = 0.1;
gamma3 = 0.2;

%% target set
data0 = shapeRectangleByCorners(g, [0; 0; 0], [0; 0; 0]);

% Put grid and dynamic systems into schemeData
schemeData.grid = g;
schemeData.dynSys = sys;
schemeData.accuracy = 'medium'; %set accuracy
schemeData.uMode = uMode;



%% Compute value function
[data1,tau1] = ComputeHJ(data0,tau,schemeData,1,gamma1);
%[data2,tau2] = ComputeHJ(data0,tau,schemeData,2,gamma2);
%[data3,tau3] = ComputeHJ(data0,tau,schemeData,3,gamma3);
mind = min(data1,[],'all');
data1 = data1 - mind;
%mind = min(data2,[],'all');
%data2 = data3 - mind;
%mind = min(data3,[],'all');
%data3 = data3 - mind;

full.g0.data = data1;
%full.g1.data = data2;
%full.g2.data = data3;
full.g0.tau = tau1;
%full.g1.tau = tau2;
%full.g2.tau = tau3;
full.g = g;
full.tau = tau;
% Save the value function and grid 
% save('full.mat','full');
%%
function [data,tau] = ComputeHJ(data0,tau0,schemeData,n,gamma)

HJIextraArgs.visualize.valueSet = 1;
HJIextraArgs.visualize.valueFunction = 1;
HJIextraArgs.visualize.initialValueSet = 1;
HJIextraArgs.visualize.figNum = n; %set figure number
HJIextraArgs.visualize.deleteLastPlot = true; %delete previous plot as you update
HJIextraArgs.targetFunction = data0;
HJIextraArgs.convergeThreshold = 0.0015;
HJIextraArgs.stopConverge = 1;
HJIextraArgs.keepLast = 1;
HJIextraArgs.ignoreBoundary = 1;
schemeData.clf.gamma = gamma;
HJIextraArgs.divergeThreshold = 10;
HJIextraArgs.stopDiverge = 1;
HJIextraArgs.visualize.plotData.plotDims = [1 1 0]; %plot x, y
HJIextraArgs.visualize.plotData.projpt = 'min'; %project at x3 = 0
HJIextraArgs.visualize.viewAngle = [30,-10]; % view 2D
HJIextraArgs.visualize.viewAxis = [-5 5 -5 5 0 6];


[data, tau, ~] = ...
  HJIPDE_ZGsolve(data0, tau0, schemeData, 'minCLF', HJIextraArgs);

end
