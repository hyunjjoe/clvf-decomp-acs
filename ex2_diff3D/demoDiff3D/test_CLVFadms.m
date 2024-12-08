clear; close all; clc
% find ACS for subsystem: x1dot = x2 + u1, x2dot = u2
% import data: 
% V(x,t), dt, ConvThres, gamma, f(x), g(x)

sub = importdata('subsys.mat');
V = sub.g0.data(:,:,end);
grid = sub.g;
dt = 0.1;
conv = 0.00001;
gamma = 0.1;

deriv = computeGradients(grid, V);
LfV = deriv{1}.*grid.xs{2};
Lg1V = deriv{1};
Lg2V = deriv{2};
u1 = [ -1 , 1 ];
u2 = [ -0.5 , 0.5 ];


% sol = A.\b;

% Discretize u in it U space

% grid_min = [u1(1); u2(1)];
% grid_max = [u1(2); u2(2)]; 
% Nu = [9;5];         % Number of grid point
% gu = createGrid(grid_min, grid_max, Nu);
% 
% LgV = Lg1V(:)*gu.xs{1}(:)' + Lg2V(:)*gu.xs{2}(:)' ;
% LgV = reshape(LgV,101,101,9,5);

%% 


% iz1 = find(abs(Lg1V) <= 1e-5);
% ip1 = find(Lg1V > 1e-5);
% in1 = find(Lg1V < -1e-5);

iz2 = find(abs(Lg2V) <= 1e-5);
ip2= find(Lg2V > 1e-5);
in2 = find(Lg2V < -1e-5);

A = Lg2V;
b = conv/dt - gamma*V - LfV - u1(1)*(Lg1V>-1e-5)-u1(2)*(Lg1V<1e-5);
sol = A.\b;
%% create arrays
% u_1_min = zeros(size(V));
% u_1_max = zeros(size(V));

u_2_min = zeros(size(V));
u_2_max = zeros(size(V));


%% solve for u_ad
% LgV = 0: u_adms = [u_min,u_max] 
% u_1_min(iz1) = u1(1);
% u_1_max(iz1) = u1(2);

u_2_min(iz2) = u2(1);
u_2_max(iz2) = u2(2);


% LgV > 0: u_adms = [u_min,sol] 
% u_1_min(ip1) = u1(1);
% u_1_max(ip1) = max(u1(1),min(u1(2),sol(ip)));

u_2_min(ip2) = u2(1);
u_2_max(ip2) = max(u2(1),min(u2(2),sol(ip2)));

% LgV < 0: u_adms = [sol,u_max] 
u_2_max(in2) = u2(2);
u_2_min(in2) = min(u2(2),max(u2(1),sol(in2)));


%% combine ACS
u.max = u_2_max;

u.min = u_2_min;

% [combined , i_exclude]= combine_admis_clvf(u, grid, u, grid);


dim_x = size(u_2_max, 1);
dim_y = size(u_2_max, 1);
dim_z = size(u_2_max, 2);

grid_min = [grid.min(1); grid.min(1); grid.min(2)];
grid_max = [grid.max(1); grid.max(1); grid.max(2)]; 
pdDims = 3;               
N = [dim_x;dim_y; dim_z];         % Number of grid point
g3d = createGrid(grid_min, grid_max, N, pdDims);

% index = find(i_exclude == 1);
% x1 = g3d.xs{1};
% x2 = g3d.xs{2};
% x3 = g3d.xs{3};
% xs = [x1(index),x2(index),x3(index)];
% recon = importdata('data_recon.mat');
% Vrec = recon.datag00;
% level = min(eval_u(g3d, Vrec, xs, 'cubic'),[],'all');
% figure
% plot3(x1(index),x2(index),x3(index),'r.')
% hold on
% visSetIm(g3d,Vrec,'blue',level);
% view(60,45)
% xlabel('x_1')
% ylabel('x_2')
% zlabel('x_3')
% xlim([-2,2])
% ylim([-2,2])
% zlim([-2,2])

%%
% 
u1_max_expand = permute(repmat(u_2_max,[1 1 dim_y]), [1 3 2]);
u2_max_expand = permute(repmat(u_2_max,[1 1 dim_x]), [3 1 2]);

u1_min_expand = permute(repmat(u_2_min,[1 1 dim_y]), [1 3 2]);
u2_min_expand = permute(repmat(u_2_min,[1 1 dim_x]), [3 1 2]);

u_max_combine= min(u1_max_expand, u2_max_expand);
u_min_combine = max(u1_min_expand, u2_min_expand);

i_exclude = u_min_combine > u_max_combine;
num_exclusions = nnz(i_exclude);
total_elements = numel(i_exclude);
percentage_exclusions = (num_exclusions / total_elements) * 100;
fprintf('Percentage of exclusions: %.2f%%\n', percentage_exclusions);

i_exist =  u_min_combine <= u_max_combine;
num_exist = nnz(i_exist);
total = numel(i_exist);
perc = 100*(num_exist/total);
fprintf('Percentage of existing: %.2f%%\n', perc);
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
visFuncIm(grid,u_2_min,'b',0.7);
hold on
visFuncIm(grid,u_2_max,'r',0.7);
xlabel('x_1')
ylabel('x_3')
legend('min','max')
zlim([-1.5,1.5 ])
