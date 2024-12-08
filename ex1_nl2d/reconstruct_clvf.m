close all
clear 
clc
%% 1. Take maximum from all of the decomposed CLVFs
data1g0 = importdata("data_sys1_g00_c0002.mat");
data2g0 = importdata("data_sys2_g00_c0002.mat");
data1g1 = importdata("data_sys1_g01_c0002.mat");
data2g1 = importdata("data_sys2_g01_c0002.mat");
data1g2 = importdata("data_sys1_g03_c0002.mat");
data2g2 = importdata("data_sys2_g03_c0002.mat");
data1g5 = importdata("data_sys1_g05_c0002.mat");
data2g5 = importdata("data_sys2_g05_c0002.mat");


g1 = importdata("g_sys1.mat");
g2 = importdata("g_sys2.mat");
grid_min = [g1.min(1); g2.min(1)];
grid_max = [g1.max(1); g2.max(1)]; 

N = [g1.N(1); g2.N(1)];
g = createGrid(grid_min, grid_max, N);

%The BRS Intersection of the two subsystem
dim_x = size(data1g0, 1);
dim_y = size(data2g0, 1);

data1g0_expand = permute(repmat(data1g0,[1 dim_y]), [1 2]);
data2g0_expand = permute(repmat(data2g0,[1 dim_x]), [2 1]);

data1g1_expand = permute(repmat(data1g1,[1 dim_y]), [1 2]);
data2g1_expand = permute(repmat(data2g1,[1 dim_x]), [2 1]);

data1g2_expand = permute(repmat(data1g2,[1 dim_y]), [1 2]);
data2g2_expand = permute(repmat(data2g2,[1 dim_x]), [2 1]);

data1g5_expand = permute(repmat(data1g5,[1 dim_y]), [1 2]);
data2g5_expand = permute(repmat(data2g5,[1 dim_x]), [2 1]);

data_intersection1 = max(data1g0_expand, data2g0_expand);
data_intersection2 = max(data1g1_expand, data2g1_expand);
data_intersection3 = max(data1g2_expand, data2g2_expand);
data_intersection5 = max(data1g5_expand, data2g5_expand);

data_recon.datag00 = data_intersection1;
data_recon.datag01 = data_intersection2;
data_recon.datag03 = data_intersection3;
data_recon.datag05 = data_intersection5;

save('data_recon','data_recon')