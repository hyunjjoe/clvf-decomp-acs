clear; close all; clc
% find ACS for subsystem: x1dot = x2 , x2dot = u1
%% import data: 
% V(x,t), dt, ConvThres, gamma, f(x), g(x)

sub = importdata('subsys.mat');
V = sub.g0.data(:,:,end);
grid = sub.g;
dt = 0.1;
conv = 0.005;
gamma = 0.1;

deriv = computeGradients(grid, V);
LfV = deriv{1}.*grid.xs{2};
LgV = deriv{2};

A = LgV;
b = conv/dt - gamma*V - LfV;
sol = A.\b;
u = [-1,1];
iz = find(abs(LgV) <= 1e-5);
ip = find(LgV > 1e-5);
in = find(LgV < -1e-5);


%% create arrays
u_ad_min = zeros(size(V));
u_ad_max = zeros(size(V));
% u_ad = cell(2,1);


%% solve for u_ad
% LgV = 0: u_adms = [u_min,u_max] 
u_ad_min(iz) = u(1);
u_ad_max(iz) = u(2);



% LgV > 0: u_adms = [u_min,sol] 
u_ad_min(ip) = u(1);
u_ad_max(ip) = max(u(1),min(u(2),sol(ip)));

% LgV < 0: u_adms = [sol,u_max] 
u_ad_max(in) = u(2);
u_ad_min(in) = min(u(2),max(u(1),sol(in)));


%% combine ACS
u1.max = u_ad_max;
u2.max = u_ad_max;

u1.min = u_ad_min;
u2.min = u_ad_min;

[combined , index]= combine_admis_clvf(u1, grid, u2, grid);

dim_x = size(u_ad_max, 1);
dim_y = size(u_ad_max, 1);
dim_z = size(u_ad_max, 2);

grid_min = [grid.min(1); grid.min(1); grid.min(2)];
grid_max = [grid.max(1); grid.max(1); grid.max(2)]; 
pdDims = 3;               
N = [dim_x;dim_y; dim_z];         % Number of grid point
g3d = createGrid(grid_min, grid_max, N, pdDims);
x1 = g3d.xs{1};
x2 = g3d.xs{2};
x3 = g3d.xs{3};
xs = [x1(index),x2(index),x3(index)];
recon = importdata('data_recon.mat');
Vrec = recon.datag00;
level = min(eval_u(g3d, Vrec, xs, 'cubic'),[],'all');
% S_value = ones(101,101,101);
% index = find(combined==0);
% rind = unique(index);
% rind = rind(find(~isnan(rind)));
% S_value(rind) = 0;
S_gamma_end.level = level; 
S_gamma_end.ex = xs; 
save('S_gamma_end.mat','S_gamma_end');
figure
plot3(x1(index),x2(index),x3(index),'r.')
hold
visSetIm(g3d,Vrec,'blue',level);
view(60,45)
xlabel('x_1')
ylabel('x_2')
zlabel('x_3')

% 
% u1_max_expand = permute(repmat(u_ad_max,[1 1 dim_y]), [1 3 2]);
% u2_max_expand = permute(repmat(u_ad_max,[1 1 dim_x]), [3 1 2]);
% 
% u1_min_expand = permute(repmat(u_ad_min,[1 1 dim_y]), [1 3 2]);
% u2_min_expand = permute(repmat(u_ad_min,[1 1 dim_x]), [3 1 2]);
% 
% u_max_combine= min(u1_max_expand, u2_max_expand);
% u_min_combine = max(u1_min_expand, u2_min_expand);
% 
% i_exclude = u_min_combine > u_max_combine;
% num_exclusions = nnz(i_exclude);
% total_elements = numel(i_exclude);
% percentage_exclusions = (num_exclusions / total_elements) * 100;
% fprintf('Percentage of exclusions: %.2f%%\n', percentage_exclusions);
% 
% i_exist =  u_min_combine <= u_max_combine;
% num_exist = nnz(i_exist);
% total = numel(i_exist);
% perc = 100*(num_exist/total);
% fprintf('Percentage of existing: %.2f%%\n', perc);
%%
% 

% 
% [gp,u1p] = proj(g3d,u1_min_expand,[0,1,0], 2);
% [~,u1p1] = proj(g3d,u1_min_expand,[0,1,0], 0);
% [~,u1p2] = proj(g3d,u1_min_expand,[0,1,0], -1);
% 
% figure
% subplot(2,2,1)
% visFuncIm(gp,u1p,'b',0.7)
% subplot(2,2,2)
% visFuncIm(gp,u1p1,'b',0.7)
% subplot(2,2,3)
% visFuncIm(gp,u1p2,'b',0.7)
% subplot(2,2,4)
% visFuncIm(grid,u_ad_min,'b',0.7)

figure
visFuncIm(grid,u_ad_min,'b',0.7);
hold on
visFuncIm(grid,u_ad_max,'r',0.7);
xlabel('x_1')
ylabel('x_3')
legend('min','max')
zlim([-1.5,1.5 ])
