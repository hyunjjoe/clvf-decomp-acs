close all
clear 
clc

%% 1. Take maximum from all of the decomposed CLVFs
data1 = importdata("data_sys1.mat");
data2 = importdata("data_sys2.mat");
g1 = importdata("g_sys1.mat");
g2 = importdata("g_sys2.mat");
grid_min = [g1.min(1); g2.min(1); g1.min(2)];
grid_max = [g1.max(1); g2.max(1); g2.max(2)]; 
pdDims = 3;               
N = [g1.N(1); g2.N(1); g2.N(2)];
g = createGrid(grid_min, grid_max, N, pdDims);

%The BRS Intersection of the two subsystem
dim_x = size(data1, 1);
dim_y = size(data2, 1);

data1_expand = permute(repmat(data1,[1 1 dim_y]), [1 3 2]);
data2_expand = permute(repmat(data2,[1 1 dim_x]), [3 1 2]);
data_intersection = data1_expand+data2_expand;
%data_intersection = max(data1_expand, data2_expand);
[g2d, data2d] = proj(g, data_intersection, [0,0,1]);

%% 2. Synthesize admissible control by taking intersection of decomposed ACSs
decomposed = importdata("decomposed.mat");
admiss1 = decomposed.part1.admiss;
admiss2 = decomposed.part2.admiss;
combined = combine_admis_clvf(admiss1, decomposed.g, admiss2, decomposed.g);
u_min_combine = combined.u_min;
u_max_combine = combined.u_max;
u_adms = 0.5*(u_max_combine+u_min_combine);
dt = decomposed.dt;

%% 3. Refine the CLVF through the admissible control
g_full = importdata("g_fullsys.mat");
data_full = importdata("data_fullsys.mat");
[g_orig_2d, data_orig_2d] = proj(g_full, data_full, [0,0,1]);

wRange = [-3, 3];
dRange = {[0;0;0];[0; 0; 0]};
speed = 1;
dCar = DubinsFullCar([0, 0, 0], wRange, speed, dRange);
data_new_mid = refine_clvf(g_full, data_intersection, dt, u_adms, dCar);
[g_full_2d, data_new_2d] = proj(g_full, data_new_mid, [0,0,1]);


%% 4. Visual
visFuncIm(g_orig_2d, data_orig_2d,'red',0.5);
hold on;
visFuncIm(g2d, data2d, 'blue', 0.5);
%visFuncIm(g_full_2d, data_new_2d,'green',0.5);

eps = 1;
min_full = min(data_full,[],'all');
%visSetIm(g_full,data_full,'red',min_full+eps);
%hold on;
min_new = min(data_new_mid,[],'all');
%visSetIm(g_full,data_new_mid,'green',min_new+eps);
min_int = min(data_intersection,[],'all');
%visSetIm(g, data_intersection,'blue',min_int+eps);