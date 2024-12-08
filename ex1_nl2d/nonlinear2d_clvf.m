close all
clear 
clc

%% Should we compute the trajectory?
compTraj = true;

%% Grid
grid_min = [-2; -2]; % Lower corner of computation domain
grid_max = [2; 2];    % Upper corner of computation domain
N = [201; 201];         % Number of grid points per dimension
g = createGrid(grid_min, grid_max, N);
    
%% time vector
t0 = 0;
tMax = 50;
dt = 0.05;
tau = t0:dt:tMax;

%% problem parameters
% control trying to min or max value function?
uMode = 'min';

uRange = {[-4,4]; [-1,1]};
sys = nonlinear2d([0, 0], uRange);

gamma1 = 0;
gamma2 = 0.1;
gamma3 = 0.3;
gamma5 = 0.5;

%% target set
R = 0;
data0 = shapeRectangleByCorners(g, [0, 0],[0, 0]);

% Put grid and dynamic systems into schemeData
schemeData.grid = g;
schemeData.dynSys = sys;
schemeData.accuracy = 'veryHigh'; %set accuracy
schemeData.uMode = uMode;



%% Compute value function
%disp(sys1)
[data1,tau1] = ComputeHJ(data0,tau,schemeData,1,gamma2);
% [data2,tau2] = ComputeHJ(data00,tau,schemeData,2,gamma2);
% [data3,tau3] = ComputeHJ(data0,tau,schemeData,3,gamma3);
% % [data4,tau4] = ComputeHJ(data01,tau,schemeData,4,gamma3);
%mind = min(data1,[],'all');
%data1 = data1 - mind;
% Save the value function and grid 
% save('data_full_g05_c0002.mat','data1')
% save('g_full.mat','g')


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
HJIextraArgs.divergeThreshold = 3;
HJIextraArgs.stopDiverge = 1;


[data, tau, ~] = ...
  HJIPDE_ZGsolve(data0, tau0, schemeData, 'minCLF', HJIextraArgs);

end
