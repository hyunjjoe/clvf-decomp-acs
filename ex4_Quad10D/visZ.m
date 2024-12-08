%This is a test file to see different functions
clear; close all; clc

%% import the grid and value functions
g = importdata('Zdata/g01_2norm.mat');

V_2norm = importdata('Zdata/V01_2norm.mat');
V_2min = min(V_2norm,[],'all');
V_2norm = V_2norm - V_2min;
V_2norm_WS = importdata('Zdata/V01_2norm_WS.mat');
V_2min_WS = min(V_2norm_WS,[],'all');
V_2norm_WS = V_2norm_WS - V_2min_WS;
% 
% V_infnorm = importdata('V_infnorm_bad.mat');
% V_imin = min(V_infnorm,[],'all');
% V_infnorm = V_infnorm - V_imin;
% 
% V_quadcost = importdata('V_Quacost_bad.mat');
% V_qmin = min(V_quadcost,[],'all');
% V_quadcost = V_quadcost - V_qmin;
% 
% x_2n = importdata('traj_2n.mat');
% x_in = importdata('traj_in.mat');
% x_qc = importdata('traj_qc.mat');



%% figures
az = 40;
el = 50;
a = 0.09;


% figure
% set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.6]);
% visFuncIm(g,V_2norm-V_2norm_WS,'b',0.6)
% hold on
% visFuncIm(g,V_2norm_WS,'r',0.6)



% figure
% set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.6]);
% 
% subplot(2,3,1)
% c = camlight;
% c.Position = [-30 -30 -30];
% view(az,el);
% visFuncIm(g_p,V_2p,'b',0.6)
% hold on 
% visSetIm(g_p,V_2p,'k',a)
% grid off
% xlabel('$x_1$','interpreter','latex','FontSize',25);
% ylabel('$x_2$','interpreter','latex','FontSize',25);
% zlabel('$V^\infty$','interpreter','latex','FontSize',25);
% title('Using 2-norm','interpreter','latex','FontSize',20)
% 
% subplot(2,3,2)
% c = camlight;
% c.Position = [-30 -30 -30];
% view(az,el);
% visFuncIm(g_p,V_ip,'r',0.6)
% hold on
% visSetIm(g_p,V_ip,'k',a)
% grid off
% xlabel('$x_1$','interpreter','latex','FontSize',25);
% ylabel('$x_2$','interpreter','latex','FontSize',25);
% % zlabel('$V^\infty$','interpreter','latex','FontSize',25);
% title('Using infinity-norm','interpreter','latex','FontSize',20)
% 
% subplot(2,3,3)
% c = camlight;
% c.Position = [-30 -30 -30];
% view(az,el);
% visFuncIm(g_p,V_qp,'c',0.6)
% hold on
% visSetIm(g_p,V_qp,'k',a)
% grid off
% xlabel('$x_1$','interpreter','latex','FontSize',25);
% ylabel('$x_2$','interpreter','latex','FontSize',25);
% % zlabel('$V^\infty$','interpreter','latex','FontSize',25);
% title('Using quadratic-cost','interpreter','latex','FontSize',20)
% 
% subplot(2,3,4)
% view(az,el);
% visSetIm(g,V_2norm,'b',a)
% hold on
% plot3(x_2n(1,:),x_2n(2,:),x_2n(3,:),'linewidth',2,'color','k')
% xlabel('$x_1$','interpreter','latex','FontSize',25);
% ylabel('$x_2$','interpreter','latex','FontSize',25);
% zlabel('$x_3$','interpreter','latex','FontSize',25);
% 
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
fig = figure;
set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.3]);

subplot(1,3,1)
visFuncIm(g,V_2norm,'b',0.7)
c = camlight;
c.Position = [-30 -30 -30];
view(az,el);
grid off
set(gca,'zTick',0:0.5:1.6);
a = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',a,'fontsize',18);
xlabel('$x_1$','interpreter','latex','FontSize',25);
ylabel('$x_2$','interpreter','latex','FontSize',25);
zlabel('$V^\infty_\gamma$','interpreter','latex','FontSize',25);
title('w/o Warmstart','interpreter','latex','FontSize',20)

subplot(1,3,2)
visFuncIm(g,V_2norm_WS,'r',0.7)
c = camlight;
c.Position = [-30 -30 -30];
view(az,el); 
grid off
set(gca,'zTick',0:0.5:1.6);
a = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',a,'fontsize',18);
xlabel('$x_1$','interpreter','latex','FontSize',25);
ylabel('$x_2$','interpreter','latex','FontSize',25);
title('with Warmstart','interpreter','latex','FontSize',20)

subplot(1,3,3)

visFuncIm(g,V_2norm - V_2norm_WS,'c',0.7)
c = camlight;
c.Position = [-30 -30 -30];
view(az,el);
grid off
% set(gca,'zTick',-1e-2: 5*1e-3 :1e-2);
% a = gca
% a = get(gca,'ZTickLabel');
set(gca,'fontsize',18);
xlabel('$x_1$','interpreter','latex','FontSize',25);
ylabel('$x_2$','interpreter','latex','FontSize',25);
title('Difference','interpreter','latex','FontSize',20)
