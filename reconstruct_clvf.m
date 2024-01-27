close all
clear 
clc
%We reconstruct the full system CLVF
%1. Take maximum from all of the decomposed CLVFs
data1 = importdata("data_sys1.mat");
data2 = importdata("data_sys2.mat");
g1 = importdata("g_sys1.mat");
g2 = importdata("g_sys2.mat");
%% Step 1: form a combined grid
grid_min = [g1.min(1); g2.min(1); g1.min(2)];
grid_max = [g1.max(1); g2.max(1); g2.max(2)]; 
pdDims = 3;               
N = [g1.N(1); g2.N(1); g2.N(2)];         % Number of grid point
g = createGrid(grid_min, grid_max, N, pdDims);
% Back project the value funct to higher dim
%repmat <--- Try this
%% The BRS Intersection of the two subsystem
dim_x = size(data1, 1);
dim_y = size(data2, 1);
data1_expand = permute(repmat(data1,[1 1 1 dim_y]), [1 4 2 3]);
data2_expand = permute(repmat(data2,[1 1 1 dim_x]), [4 1 2 3]);
data_intersection = max(data1_expand, data2_expand);
[g2d, data2d] = proj(g, data_intersection, [0,0,1]);
%visFuncIm(g2d,data2d,'blue',0.5);
%hold on;
%v_fullsys = importdata("data_fullsys.mat");
%2. Synthesize admissible control by taking intersection of decomposed ACSs
% OR use the combine function built by Chong
decomposed = importdata("decomposed.mat");
admiss1 = decomposed.part1.admiss;
admiss2 = decomposed.part2.admiss;
combined = combine(admiss1, decomposed.g, admiss2, decomposed.g, 'min', [-3, 3]);
%[gAdmiss1, admiss1_2d] = proj(decomposed.g, admiss1.u_max, [0,0,1]);
%[gAdmiss2, admiss2_2d] = proj(decomposed.g, admiss2.u_max, [0,0,1]);
%visFuncIm(gAdmiss1,admiss1_2d,'blue',0.5)
%visFuncIm(gAdmiss2,admiss2_2d,'blue',0.5)
u_min_combine = combined.u_min;
u_max_combine = combined.u_max;
u_adms = 0.5*(u_max_combine+u_min_combine);
%disp(max(u_min_combine,[],'all'));
% Look into this further. Use VisFuncIm -> overlay the two lookup tables of
% the admissible control, or side-by-side

%3. Refine the CLVF through the admissible control
g_full = importdata("g_fullsys.mat");
data_full = importdata("data_fullsys.mat");
[g_orig_2d, data_orig_2d] = proj(g_full, data_full, [0,0,1]);
%visFuncIm(g_orig_2d, data_orig_2d,'red',0.5);

t0 = 0;
tMax = 1;
dt = 0.05;
tau_full = t0:dt:tMax;
wRange = [-3, 3];
dRange = {[0;0;0];[0; 0; 0]};
speed = 1;
dCar = DubinsFullCar([0, 0, 0], wRange, speed, dRange);
data_new_mid = StateWAdms(g_full, data_intersection, tau_full, u_adms, dCar);
[g_full_2d, data_new_2d] = proj(g_full, data_new_mid, [0,0,1]);
%visFuncIm(g_full_2d, data_new_2d,'green',0.5);
eps = 0.5;
min_full = min(data_full,[],'all');
visSetIm(g_full,data_full,'red',min_full+eps);
hold on;
min_new = min(data_new_mid,[],'all');
visSetIm(g_full,data_new_mid,'green',min_new+eps);
min_int = min(data_intersection,[],'all');
visSetIm(g, data_intersection,'blue',min_int+eps);