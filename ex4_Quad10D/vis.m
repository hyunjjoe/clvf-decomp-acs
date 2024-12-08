%This is a test file to see different functions
clear; close all; clc

%% import the grid and value functions
Zdata = importdata('Zdata.mat');
g_Z = Zdata.g;
V_2norm_Z = Zdata.V;
V_2norm_Z = V_2norm_Z - min(V_2norm_Z,[],'all');

Xdata = importdata('Xdata.mat');
g_X = Xdata.g;
V_2norm_X = Xdata.V;
V_2min_X = min(V_2norm_X,[],'all');
V_2norm_X = V_2norm_X - V_2min_X;

[g_X_3p,V_X_3p] = proj(g_X,V_2norm_X,[0 0 0 1],'min');
[g_X_2p,V_X_2p] = proj(g_X_3p,V_X_3p,[0 0 1],'min');


xs = importdata('Traj.mat');

%% Reconstruct CLVF:

[g_Zp,V_Zp] = proj(g_Z,V_2norm_Z,[0 1],'min');
[g_Xp,V_Xp] = proj(g_X,V_2norm_X,[0 1 1 1],'min');

grid_min = [g_Xp.min; g_Xp.min; g_Zp.min];
grid_max = [g_Xp.max; g_Xp.max; g_Zp.max]; 
N = [g_Xp.N; g_Xp.N; g_Zp.N];
g = createGrid(grid_min, grid_max, N);

V_X_expand = repmat(V_Xp,[1 , size(V_Xp,1) , size(V_Zp,1)]);
V_Z_expand = permute(repmat(V_Zp,[1 , size(V_Xp,1) , size(V_Xp,1)] ),...
                    [3,2,1]);
V_Y_expand = permute(V_X_expand,[2,1,3] );
V_3D = V_X_expand+V_Y_expand+V_Z_expand;



%% figures
az = 40;
el = 30;
a = 0.001;

figure
set(gcf,'unit','normalized','position',[0.2,0.2,0.6,0.45]);

t = tiledlayout('flow');
nexttile(t)

S = plot3(0,0,0,'ro','lineWidth', 2,'MarkerSize',10,'MarkerFaceColor','r');
view(az,el);
hold on
T = plot3(xs.x(1,:), xs.x(5,:), xs.x(9,:),...
'lineWidth',1.5,'color','b','lineStyle','--');
hold on
IC = plot3(xs.x(1,1), xs.x(5,1), xs.x(9,1),'ms','MarkerSize',10, ...
    'lineWidth',2,'MarkerFaceColor','m');
% xlim([-1,1]);
% ylim([-1,1]);

a = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',a,'fontsize',18);
grid off
xlabel('$x_1$','interpreter','latex','FontSize',25);
ylabel('$x_5$','interpreter','latex','FontSize',25);
zlabel('$x_9$','interpreter','latex','FontSize',25);
title('Optimal Traj','interpreter','latex','FontSize',20)

nexttile(t)
V = plot(xs.t,xs.V,'lineWidth',2,'color','b');
% hold on
% plot3(x_2n(1,:),x_2n(2,:),x_2n(3,:),'linewidth',2,'color','k')
a = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',a,'fontsize',18);
xlabel('$t$','interpreter','latex','FontSize',25);
ylabel('$V^\infty_\gamma(t)$','interpreter','latex','FontSize',25);
title('Value along Traj','interpreter','latex','FontSize',20)

lgd = legend([S,T,IC,V],{'Origin','Opt Traj', 'Initial State',...
    'Value along Traj'},'Orientation','horizontal','interpreter','latex', ...
    'FontSize',18);

% subplot(2,3,5)
% view(az,el);
% visSetIm(g,V_infnorm,'r',a)
% hold on
% plot3(x_in(1,:),x_in(2,:),x_in(3,:),'linewidth',2,'color','k')
% xlabel('$x_1$','interpreter','latex','FontSize',25);
% ylabel('$x_2$','interpreter','latex','FontSize',25);
% zlabel('$x_3$','interpreter','latex','FontSize',25);
% 
% subplot(2,3,6)
% view(az,el);
% visSetIm(g,V_quadcost,'c',a)
% hold on
% plot3(x_qc(1,:),x_qc(2,:),x_qc(3,:),'linewidth',2,'color','k')
% xlabel('$x_1$','interpreter','latex','FontSize',25);
% ylabel('$x_2$','interpreter','latex','FontSize',25);
% zlabel('$x_3$','interpreter','latex','FontSize',25);
% 


%% 
% figure
% set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.4]);
% 
% subplot(1,3,1)
% view(az,el);
% visSetIm(g,V_2norm,'b',a)
% hold on
% plot3(x_2n(1,:),x_2n(2,:),x_2n(3,:),'linewidth',2,'color','k')
% 
% subplot(1,3,2)
% view(az,el);
% visSetIm(g,V_infnorm,'r',a)
% hold on
% plot3(x_in(1,:),x_in(2,:),x_in(3,:),'linewidth',2,'color','k')
% 
% subplot(1,3,3)
% view(az,el);
% visSetIm(g,V_quadcost,'c',a)
% hold on
% plot3(x_qc(1,:),x_qc(2,:),x_qc(3,:),'linewidth',2,'color','k')
