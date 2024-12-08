close all
clear 
clc
sub = importdata("subsys.mat");
gam = 'gamma00';
switch gam
    case 'gamma00'
        datas1 = sub.g0.data;
        datas2 = sub.g0.data;
        tau = sub.g0.tau;
        schemeData.clf.gamma = 0.1;
    case 'gamma01'
        datas1 = sub.g1.data;
        datas2 = sub.g1.data;
        tau = sub.g1.tau;
        schemeData.clf.gamma = 0.1;
end
dt = sub.dt;

%% Grid
grid_min = [-2; -2; -2]; % Lower corner of computation domain
grid_max = [2; 2; 2];    % Upper corner of computation domain
N = [101; 101; 101];         % Number of grid points per dimension
g = createGrid(grid_min, grid_max, N);
x = g.xs;

%% dyn sys
uRange = [-1, 1];
dynSys = doubleInt3D([0, 0, 0], uRange);
subSys = doubleIntSub([0, 0], uRange);

%% SchemeData for admis
schemeData.grid = sub.g;
schemeData.dynSys = subSys;
schemeData.accuracy = 'veryHigh'; %set accuracy
schemeData.uMode = 'min';

%% Recon States
xs = zeros(prod(g.N, 'all'),3);
xs(:,1) = reshape(x{1}, 1, []);
xs(:,2) = reshape(x{2}, 1, []);
xs(:,3) = reshape(x{3}, 1, []);

reind = nan; 
%% Reverse time of TV-CLVFs
% for i = length(tau):-1:2
tic
for i = 1:1: length(tau)-1

    %% Compute subsys ACSs
%     [u_ad_min1, u_ad_max1] = subSys.admis(datas1(:,:,i), datas1(:,:,i-1), schemeData, 0.005, dt);
%     [u_ad_min2, u_ad_max2] = subSys.admis(datas2(:,:,i), datas2(:,:,i-1), schemeData, 0.005, dt);
    
    [u_ad_min1, u_ad_max1] = clvf_adms(datas1(:,:,i), datas1(:,:,i+1), schemeData, 0.005, dt);
    [u_ad_min2, u_ad_max2] = clvf_adms(datas2(:,:,i), datas2(:,:,i+1), schemeData, 0.005, dt);
    
    admiss1.min = u_ad_min1;         
    admiss1.max = u_ad_max1;
    admiss2.min = u_ad_min2;
    admiss2.max = u_ad_max2;
    %% Find intersection ACS
    [u_adms ,id] = combine_admis_clvf(admiss1, sub.g, admiss2, sub.g);
%     u = eval_u(g, u_adms, xs, 'cubic');

%     if(any(u==0))
        index = find(id==1);
        reind = [reind;index];
%         break;
%     else
%         u = eval_u(g, u_adms, xs, 'cubic');
%         dx = dynSys.dynamics(i, xs, u);  
%         xs = xs + dx * dt;
%     end
end
toc
%% Reconstruct CLVF
% initial_data = shapeRectangleByCorners(g,[0, 0, 0], [0,0,0]);
S_value = ones(101,101,101);
rind = unique(reind);
rind = rind(find(~isnan(rind)));
recon = importdata('data_recon.mat');
x1 = g.xs{1};
x2 = g.xs{2};
x3 = g.xs{3};
xs1 = [x1(index),x2(index),x3(index)];
Vrec = recon.datag00;
level = min(eval_u(g, Vrec, xs1, 'cubic'),[],'all');
% s_g = reshape(eval_u(g, initial_data, xs, 'cubic'), g.N');
S_gamma.level = level; 
S_gamma.ex = xs1; 
save('S_gamma.mat','S_gamma');
figure
% plot3(s_g())
% x1 = g.xs{1};
% x2 = g.xs{2};
% x3 = g.xs{3};
plot3(x1(index),x2(index),x3(index),'r.');
hold
visSetIm(g,Vrec,'blue',level-0.01);view(35,40);
xlabel('x_1')
ylabel('x_2')
zlabel('x_3')
%% Visualize
% [g2d, s_g2d] = proj(g,s_g,[0,0,1],'min');
% 
% empty = sum(isnan(s_g), 'all');
% total = numel(s_g);
% 
% perc = empty/total;
% 
% full = importdata("full.mat");
% full = full.g0.data;
% [~, full_2d] = proj(g, full, [0,0,1], 'min');
% visFuncIm(g2d,s_g2d,'blue',0.5);
% hold on;
% visFuncIm(g2d,full_2d,'red',0.5); hold off;