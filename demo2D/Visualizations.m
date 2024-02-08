close all; clear all; clc 

%% Input datas
g1 = importdata('g_sys1.mat');
g2 = importdata('g_sys2.mat');
g = importdata('g_full.mat');

% using 2-norm
l = shapeCylinder(g, [], [0; 0], 0);
l1 = shapeCylinder(g1, [], [0], 0);
l2 = shapeCylinder(g2, [], [0], 0);

% using infty norm
% l = shapeRectangleByCorners(g, [0,0], [0,0]);
% l1 = shapeRectangleByCorners(g1, 0, 0);
% l2 = shapeRectangleByCorners(g2, 0, 0);


V1 = importdata('data_sys1.mat');
V2 = importdata('data_sys2.mat');
V = importdata('data_full.mat');

%% Reconstruct the cost function using l = max(l1,l2)
dim_x1 = size(l1, 1);
dim_x2 = size(l2, 1);

l1_expand = permute(repmat(l1,[1 dim_x2]), [1 2]);
l2_expand = permute(repmat(l2,[1 dim_x1]), [2 1]);
l_re = max(l1_expand, l2_expand);

V1_expand = permute(repmat(V1,[1 dim_x2]), [1 2]);
V2_expand = permute(repmat(V2,[1 dim_x1]), [2 1]);
V_re = max(V1_expand, V2_expand);

V_diff = V - V_re;

%% Plot cost set

figure
set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.6]);
subplot(2,2,1)
visSetIm(g,l1_expand,'r',0.1)
title('l1 expanded')
xlabel('$x_1$','interpreter','latex','FontSize',25);
ylabel('$x_2$','interpreter','latex','FontSize',25);

subplot(2,2,2)
visSetIm(g,l2_expand,'b',0.1)
title('l2 expanded')
xlabel('$x_1$','interpreter','latex','FontSize',25);
ylabel('$x_2$','interpreter','latex','FontSize',25);

subplot(2,2,3)
visSetIm(g,l_re,'b',0.1)
title('l reconstructed')
xlabel('$x_1$','interpreter','latex','FontSize',25);
ylabel('$x_2$','interpreter','latex','FontSize',25);

subplot(2,2,4)
visSetIm(g,l,'cyan',0.1)
title('l full')
xlabel('$x_1$','interpreter','latex','FontSize',25);
ylabel('$x_2$','interpreter','latex','FontSize',25);


%% Plot cost function
figure
set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.6]);
subplot(2,2,1)
visFuncIm(g1,l1,'blue',0.5)
title('vis of cost functions')
xlabel('$x_1$','interpreter','latex','FontSize',25);
ylabel('$l$','interpreter','latex','FontSize',25);

subplot(2,2,2)
visFuncIm(g2,l2,'red',0.5)
title('vis of cost functions')
xlabel('$x_2$','interpreter','latex','FontSize',25);
ylabel('$l$','interpreter','latex','FontSize',25);

subplot(2,2,3)
visFuncIm(g,l_re,'g',0.5)
title('vis of cost functions')
xlabel('$x_1$','interpreter','latex','FontSize',25);
ylabel('$x_2$','interpreter','latex','FontSize',25);
zlabel('$l$','interpreter','latex','FontSize',25);

subplot(2,2,4)
visFuncIm(g,l,'cyan',0.5)
title('vis of cost functions')
xlabel('$x_1$','interpreter','latex','FontSize',25);
ylabel('$x_2$','interpreter','latex','FontSize',25);
zlabel('$l$','interpreter','latex','FontSize',25);

%% Plot value function
figure
set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.6]);
subplot(2,2,1)
visFuncIm(g1,V1,'blue',0.5)
title('vis of cost functions')
xlabel('$x_1$','interpreter','latex','FontSize',25);
ylabel('$V$','interpreter','latex','FontSize',25);

subplot(2,2,2)
visFuncIm(g2,V2,'red',0.5)
title('vis of cost functions')
xlabel('$x_2$','interpreter','latex','FontSize',25);
ylabel('$V$','interpreter','latex','FontSize',25);

subplot(2,2,3)
visFuncIm(g,V_re,'g',0.5)
title('vis of cost functions')
xlabel('$x_1$','interpreter','latex','FontSize',25);
ylabel('$x_2$','interpreter','latex','FontSize',25);
zlabel('$V$','interpreter','latex','FontSize',25);

subplot(2,2,4)
visFuncIm(g,V,'cyan',0.5)
title('vis of cost functions')
xlabel('$x_1$','interpreter','latex','FontSize',25);
ylabel('$x_2$','interpreter','latex','FontSize',25);
zlabel('$V$','interpreter','latex','FontSize',25);

figure
visFuncIm(g,V_diff,'black',0.5)
title('vis of cost functions')
xlabel('$x_1$','interpreter','latex','FontSize',25);
ylabel('$x_2$','interpreter','latex','FontSize',25);
zlabel('$V$','interpreter','latex','FontSize',25);

