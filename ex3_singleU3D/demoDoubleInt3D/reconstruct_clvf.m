fclose all
clear 
clc
%% 1. Take maximum from all of the decomposed CLVFs
sub = importdata("subsys.mat");

data1g0 = sub.g0.data(:,:,end);

data1g0 = data1g0 - min(data1g0,[],'all');
data2g0 = sub.g0.data(:,:,end);
data2g0 = data2g0 - min(data2g0,[],'all');

% data1g1 = sub.g1.data;
% data2g1 = sub.g1.data;
% data1g2 = sub.g2.data;
% data2g2 = sub.g2.data;

%The BRS Intersection of the two subsystem
dim_x = size(data1g0, 1);
dim_y = size(data2g0, 1);
dim_z = size(data1g0, 2);


grid_min = [-2; -2; -2]; % Lower corner of computation domain
grid_max = [2; 2; 2];    % Upper corner of computation domain
N = [dim_x; dim_y; dim_z];         % Number of grid points per dimension
g = createGrid(grid_min, grid_max, N);

%%
% data1g0_aug = repmat(data1g0,[1, 1, 1, dim_y]);

data1g0_expand = permute(repmat(data1g0,[1, 1, dim_y]), [1 3 2]);


%%
data2g0_expand = permute(repmat(data2g0,[1, 1 , dim_x]), [3,1,2]);

% data1g1_expand = permute(repmat(data1g1,[1 1, dim_y]), [1 3 2]);
% data2g1_expand = permute(repmat(data2g1,[1 1, dim_x]), [3 1 2]);

%data1g2_expand = permute(repmat(data1g2,[1 1, dim_y]), [1 3 2]);
%data2g2_expand = permute(repmat(data2g2,[1 1, dim_x]), [3 1 2]);

data_intersection1 = data1g0_expand + data2g0_expand;
% data_intersection2 = max(data1g1_expand, data2g1_expand);
%data_intersection3 = max(data1g2_expand, data2g2_expand);

data_recon.datag00 = data_intersection1;
data_recon.g = g; 
% data_recon.datag01 = data_intersection2;
%data_recon.datag02 = data_intersection3;
save('data_recon','data_recon')

%%
figure
subplot(1,3,1)
visSetIm(g,data_intersection1,'b',0.1);
view(35,40)
title('0.1-level')
subplot(1,3,2)
visSetIm(g,data_intersection1,'b',0.5);
view(35,40)
title('0.5-level')

subplot(1,3,3)
visSetIm(g,data_intersection1,'b',1);
view(35,40)
title('1-level')

