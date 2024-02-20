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
d1 =repmat(data1,[1 1, dim_x]);
d2 =repmat(data1,[1 1, dim_y]);
data1_expand = permute(repmat(data1,[1 1, dim_y]), [1 3 2]);
data2_expand = permute(repmat(data2,[1 1, dim_x]), [3 1 2]);
%data1_expand = permute(repmat(data1,[1 1 1 dim_y]), [1 4 2 3]);
%data2_expand = permute(repmat(data2,[1 1 1 dim_x]), [4 1 2 3]);
data_intersection2 = max(data1_expand, data2_expand);
%data_intersection2 = data1_expand+data2_expand;
%data_intersection = data1+data2;
data_intersection = max(data1, data2);
[g2d, data2d] = proj(g, data_intersection2, [0,0,1], [0]);
%visSetIm(g,data_intersection2,'blue', 1.2);
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



