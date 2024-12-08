close all
clear 
clc
sub = importdata('subsys.mat');
gam = 'gamma01';
switch gam
    case 'gamma01'
        datas1 = sub.g0.data;
        datas2 = sub.g0.data;
        tau = sub.g0.tau;
        schemeData.clf.gamma = 0.1;
end
dt = sub.dt;

%% Grid
dim_x = size(datas1, 1);
dim_y = size(datas2, 1);
dim_z = size(datas1, 2);
grid_min = [-2; -2; -2]; 
grid_max = [2 ; 2; 2];   
N = [dim_x; dim_y; dim_z];         
g = createGrid(grid_min, grid_max, N);
x = g.xs;

%% dyn sys
uRange = {[-1, 1], [-1, 1], [-0.5, 0.5]};
dynSys = diff3d([0, 0, 0], uRange);
uRange = {[-1, 1], [-0.5, 0.5]};
subSys = diff3dsys1([0, 0], uRange);

%% SchemeData for admis
schemeData.grid = sub.g;
schemeData.dynSys = subSys;
schemeData.accuracy = 'high'; %set accuracy
schemeData.uMode = 'min';

dim_x = size(datas1(:,:,1), 1);
dim_y = size(datas2(:,:,1), 1);

%% Recon States
xs = zeros(prod(g.N, 'all'),3);
xs(:,1) = reshape(x{1}, 1, []);
xs(:,2) = reshape(x{2}, 1, []);
xs(:,3) = reshape(x{3}, 1, []);

u = zeros(prod(g.N, 'all'),3);

reind = nan; 
%% Reverse time of TV-CLVFs
tic
for i = 1:1: length(tau)-1
    %% Compute subsys ACSs
    [u_ad_min1, u_ad_max1] = clvf_adms(datas1(:,:,i), datas1(:,:,i+1), schemeData, 0.001, dt);
    [u_ad_min2, u_ad_max2] = clvf_adms(datas2(:,:,i), datas2(:,:,i+1), schemeData, 0.001, dt);
    admiss1.min = u_ad_min1;         
    admiss1.max = u_ad_max1;
    admiss2.min = u_ad_min2;
    admiss2.max = u_ad_max2;
%     [u_diff_min, u_diff_max] = subSys.admis_diff(datas1(:,:,i), datas1(:,:,i-1), schemeData, 0.001, dt);
%     admissdiff.min = u_diff_min;
%     admissdiff.max = u_diff_max;
%     u1 = combine_admis_diff(admissdiff, sub.g, admissdiff, sub.g);
    %% Find intersection ACS
    [u_adms ,id] = combine_admis_clvf(admiss1, sub.g, admiss2, sub.g);
%     u = eval_u(g, u_adms, xs, 'cubic');    
%     if(any(u_adms==0))
        %break;
        index = find(id==1);
        reind = [reind;index];
%     else
%         u(:,1) = eval_u(g, u1, xs, 'cubic');
%         u(:,2) = eval_u(g, u1, xs, 'cubic');
%         u(:,3) = eval_u(g, u_adms, xs, 'cubic');
%         dx = dynSys.dynamics(i, xs, u);  
%         xs = xs + dx * dt;
%     end
end
toc
save('u_adms_g1.mat','u_adms')
%% Reconstruct CLVF
initial_data = shapeRectangleByCorners(g,[0, 0, 0], [0,0,0]);
rind = unique(reind);
rind = rind(find(~isnan(rind)));
recon = importdata('data_recon.mat');
x1 = g.xs{1};
x2 = g.xs{2};
x3 = g.xs{3};
xs1 = [x1(index),x2(index),x3(index)];
Vrec = recon.datag00;
level = min(eval_u(g, Vrec, xs1, 'cubic'),[],'all');

S_gamma.level = level; 
S_gamma.ex = xs1; 
save('S_gamma.mat','S_gamma');
figure
plot3(x1(index),x2(index),x3(index),'r.');
hold on
visSetIm(g,Vrec,'blue',level-0.01);view(35,40);
xlabel('x_1')
ylabel('x_2')
zlabel('x_3')

%% Visualize
% [g2d, s_g2d] = proj(g,s_g,[0,0,1],'min');
% 
% 
% empty = sum(isnan(s_g), 'all');
% total = numel(s_g);
% 
% perc = empty/total;
% 
% full = importdata("full.mat");
% full = full.g0.data;
% [~, full_2d] = proj(g, full, [0,0,1], 'min');
% figure
% visSetIm(g,s_g,'blue',1);