close all
clear 
clc

%% 1. Take maximum from all of the decomposed CLVFs
data1 = importdata("data_sys1.mat");
data2 = importdata("data_sys2.mat");
g1 = importdata("g_sys1.mat");
g2 = importdata("g_sys2.mat");
grid_min = [g1.min(1); g2.min(1)];
grid_max = [g1.max(1); g2.max(1)]; 

N = [g1.N(1); g2.N(1)];
g = createGrid(grid_min, grid_max, N);

%The BRS Intersection of the two subsystem
dim_x = size(data1, 1);
dim_y = size(data2, 1);

data1_expand = permute(repmat(data1,[1 dim_y]), [1 2]);
data2_expand = permute(repmat(data2,[1 dim_x]), [2 1]);
%data_intersection = data1_expand+data2_expand;
data_intersection = max(data1_expand, data2_expand);

%% 2. Compare with Full Sys
g_full = importdata("g_full.mat");
data_full = importdata("data_full.mat");

visFuncIm(g_full, data_full,'red',0.5);
hold on;
visFuncIm(g, data_intersection, 'blue', 0.5);
