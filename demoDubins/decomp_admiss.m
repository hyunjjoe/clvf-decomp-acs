close all
clear 
clc
% Dubins Car Example
% Compute the ACS for decomposed systems
uMode = 'min';
dMode = 'max';

gamma1 = 0;
gamma2 = 0.3;
gamma3 = 3;

%% problem parameters
dt = 0.05;
% input bounds
speed = 1;

%% Pack problem parameters
params.u_max = pi/2; % maximum control input
params.u_min  = -pi/2; % minimum control input 
wRange = [ params.u_min , params.u_max ];
% Define dynamic system
dsys1 = sys1([0, 0], wRange, speed, [0,0]);
dsys2 = sys2([0, 0], wRange, speed, [0,0]);

% Put grid and dynamic systems into schemeData
data1 = importdata("data_sys1.mat");
g1 = importdata("g_sys1.mat");
data2 = importdata("data_sys2.mat");
g2 = importdata("g_sys2.mat");

schemeData1.grid = g1;
schemeData1.dynSys = dsys1;
schemeData1.accuracy = 'high'; %set accuracy
schemeData1.uMode = uMode;
schemeData2.dMode = dMode;
schemeData1.clf.gamma = gamma1;

schemeData2.grid = g2;
schemeData2.dynSys = dsys2;
schemeData2.accuracy = 'high'; %set accuracy
schemeData2.uMode = uMode;
schemeData2.dMode = dMode;
schemeData2.clf.gamma = gamma1;

%Syntax is data,
[u_ad_min_1, u_ad_max_1, grad1_1, grad2_1] = dsys1.admis_clvf(data1,schemeData1,0.01,0.05);
[u_ad_min_2, u_ad_max_2, grad1_2, grad2_2] = dsys2.admis_clvf(data1,schemeData2,0.01,0.05);

%% Two subsystems
decomposed.part1.data = data1;
decomposed.part2.data = data2;
decomposed.part1.admiss.min = u_ad_min_1;
decomposed.part1.admiss.max = u_ad_max_1;
decomposed.part2.admiss.min = u_ad_min_2;
decomposed.part2.admiss.max = u_ad_max_2;
decomposed.part1.dynSys1 = dsys1;
decomposed.part2.dynSys2 = dsys2;
decomposed.g = g1;
decomposed.dt = dt;

u_adms1 = 0.5*(u_ad_max_1+u_ad_min_1);
u_adms2 = 0.5*(u_ad_max_2+u_ad_min_2);
visFuncIm(g1,u_adms1,'red',0.4);
hold on;
visFuncIm(g2,u_adms2,'blue',0.4);

save('demoDubins/decomposed.mat','decomposed')