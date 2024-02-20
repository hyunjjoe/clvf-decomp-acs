close all
clear 
clc

%% 1. Take maximum from all of the decomposed CLVFs
data1 = importdata("data_subsys.mat");
g1 = importdata("g_subsys.mat");
grid_min = [g1.min(1); g1.min(2); g1.min(3); g1.min(1); g1.min(2); g1.min(3)];
grid_max = [g1.max(1); g1.max(2); g1.max(3); g1.max(1); g1.max(2); g1.max(3)]; 
pdDims = [3,6];               
N = [g1.N(1); g1.N(2); g1.N(3); g1.N(1); g1.N(2); g1.N(3)];
g = createGrid(grid_min, grid_max, N, pdDims);

%The BRS Intersection of the two subsystem
dim_x = size(data1, 1);
dim_y = size(data1, 1);
d1 =repmat(data1,[1 1, dim_x]);
d2 =repmat(data1,[1 1, dim_y]);
data1_expand = permute(repmat(data1,[1 1, dim_y]), [1 3 2]);
data2_expand = permute(repmat(data2,[1 1, dim_x]), [3 1 2]);

data_intersection = max(data1_expand, data2_expand);

[g2d, data2d] = proj(g, data_intersection2, [0,0,1], [0]);
%visSetIm(g,data_intersection2,'blue', 1.2);
%% 2. Synthesize admissible control by taking intersection of decomposed ACSs

%% 3. Refine the CLVF through the admissible control
g_full = importdata("demoDubins/g_fullsys.mat");
data_full = importdata("demoDubins/data_fullsys.mat");
[g_orig_2d, data_orig_2d] = proj(g_full, data_full, [0,0,1], [0]);
%[gPlot, dataPlot] = proj(gPlot, dataPlot, ~plotDimsTemp, projpt{ii});
emptysets = find(u_adms==0);
uplot = zeros(size(data_intersection));
%uplot(emptysets) = data_intersection(emptysets);
%scatter3(g_orig_2d.xs(1), g_orig_2d.xs(2), uplot);

[gsys1, datasys1] = proj(g, data1_expand, [0,1,0]);
[gsys2, datasys2] = proj(g, data2_expand, [0,0,1]);
%datatog = max(datasys1,datasys2);
%% 4. Visual
%visFuncIm(g_orig_2d, data_orig_2d,'red',0.5);
%hold on;
%visFuncIm(g2d, data2d, 'black', 0.5);
visFuncIm(gsys1, datasys1, 'green', 0.5);
%visFuncIm(gsys2, datasys2, 'blue', 0.5);
%visFuncIm(g1, data_intersection, 'blue', 0.5);



