close all
clear 
clc

% Define a variable for font size
fontSize = 25;
titleSize = 20;
%Load Value Function
recon = importdata("data_recon.mat");
recon_g00 = recon.datag00;
recon_g01 = recon.datag01;
recon_g03 = recon.datag03;
recon_g05 = recon.datag05;

g = importdata("g_full.mat");

full_g00 = importdata("data_full_g00_c0002.mat");
full_g01 = importdata("data_full_g01_c0002.mat");
full_g03 = importdata("data_full_g03_c0002.mat");
full_g05 = importdata("data_full_g05_c0002.mat");

sub1g1 = importdata("data_sys1_g01_c0002.mat");
sub2g1 = importdata("data_sys2_g01_c0002.mat");
sub1g3 = importdata("data_sys1_g03_c0002.mat");
sub2g3 = importdata("data_sys2_g03_c0002.mat");
g_sub = importdata("g_sys1.mat");

eps = 2;

% %%
% figure
% set(gcf,'unit','normalized','position',[0.2,0.2,0.6,0.6]);
% 
% s1 = subplot(2,2,1);
% set(gca,'Position', [ 0.1, 0.6, 0.3, 0.3]) % subplot 1
% 
% g1 = visFuncIm(g_sub, sub1g1,'green',0.5);
% hold on;
% g2 = visFuncIm(g_sub, sub1g3, 'm', 0.5);
% hold off;
% set(gca ); % Make tick labels bold
% set(gca,'yTick',[0:1:2]);
% set(gca,'xTick',[-2:2:2]);
% zx1 = get(gca,'ZTickLabel');
% set(gca,'ZTickLabel',zx1,'fontsize',25);
% xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', fontSize );
% ylabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex', 'FontSize', fontSize );
% ylim([0,2]);
% title('Subsystem 1', 'Interpreter', 'latex', 'FontSize', titleSize );
% grid off;
% s1.Position = [s1.Position(1), s1.Position(2)+0.025, s1.Position(3)*0.8, s1.Position(4)];
% 
% 
% s2 = subplot(2,2,2);
% set(gca,'Position', [ 0.5, 0.6, 0.3, 0.3]) % subplot 1
% 
% visFuncIm(g_sub, sub2g1,'green',0.5);
% hold on;
% visFuncIm(g_sub, sub2g3, 'm', 0.5);
% hold off;
% set(gca ); % Make tick labels bold
% set(gca,'yTick',[0:1:2]);
% set(gca,'xTick',[-2:2:2]);
% zx1 = get(gca,'ZTickLabel');
% set(gca,'ZTickLabel',zx1,'fontsize',25);
% xlabel('$x_2$', 'Interpreter', 'latex', 'FontSize', fontSize );
% ylabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex', 'FontSize', fontSize );
% ylim([0,2]);
% title('Subsystem 2', 'Interpreter', 'latex', 'FontSize', titleSize );
% grid off;
% s2.Position = [s2.Position(1), s2.Position(2)+0.025, s2.Position(3)*0.8, s2.Position(4)];
% 
% 
% 
% s3 = subplot(2,2,3);
% set(gca,'Position', [ 0.1, 0.15, 0.3, 0.3]) % subplot 1
% 
% ov = visFuncIm(g, full_g01,'red',0.5);
% hold on;
% rv = visFuncIm(g, recon_g01, 'blue', 0.5);
% ovr = visSetIm(g, full_g01,'red',eps);
% rvr = visSetIm(g, recon_g01, 'blue', eps);
% hold off;
% view(30,20)
% set(gca ); % Make tick labels bold
% set(gca,'zTick',[0:1:2]);
% set(gca,'yTick',[-2:2:2]);
% set(gca,'xTick',[-2:2:2]);
% zx1 = get(gca,'ZTickLabel');
% set(gca,'ZTickLabel',zx1,'fontsize',25);
% xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', fontSize );
% ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', fontSize );
% zlabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex', 'FontSize', fontSize );
% title('$\gamma = 0.1$', 'Interpreter', 'latex', 'FontSize', titleSize );
% grid off;
% zlim([0,2]);
% s3.Position = [s3.Position(1), s3.Position(2), s3.Position(3)*0.8, s3.Position(4)];
% 
% 
% s4 = subplot(2,2,4);
% set(gca,'Position', [ 0.5, 0.15, 0.3, 0.3]) % subplot 1
% 
% visFuncIm(g, full_g03,'red',0.5);
% hold on;
% visFuncIm(g, recon_g03, 'blue', 0.5);
% visSetIm(g, full_g03,'red',eps);
% visSetIm(g, recon_g03, 'blue', eps);
% hold off;
% view(30,20)
% set(gca ); % Make tick labels bold
% set(gca,'zTick',[0:1:2]);
% set(gca,'yTick',[-2:2:2]);
% set(gca,'xTick',[-2:2:2]);
% zx1 = get(gca,'ZTickLabel');
% set(gca,'ZTickLabel',zx1,'fontsize',25);
% xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', fontSize );
% ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', fontSize );
% zlabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex', 'FontSize', fontSize );
% title('$\gamma = 0.3$', 'Interpreter', 'latex', 'FontSize', titleSize );
% grid off;
% zlim([0,2]);
% s4.Position = [s4.Position(1), s4.Position(2), s4.Position(3)*0.8, s4.Position(4)];
% 
% lg1 = legend([g1,g2,ov,rv,ovr,rvr],{'$\gamma = 0.1$','$\gamma = 0.1$',...
%     'Orig. CLVF', 'Recon. CLVF', 'Orig. ROES', 'Recon. ROES'}, 'Interpreter', 'latex', 'FontSize', 18 );

%% New fig
figure
set(gcf,'unit','normalized','position',[0.2,0.2,0.6,0.35]);

s1 = subplot(1,3,1);
set(gca,'Position', [ 0.1, 0.35, 0.2, 0.55]) % subplot 1

sub1 = visFuncIm(g_sub, sub1g1,'cyan',1);
hold on;
set(gca ); % Make tick labels bold
set(gca,'yTick',[0:1:2]);
set(gca,'xTick',[-2:2:2]);
zx1 = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',zx1,'fontsize',25);
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', fontSize );
ylabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex', 'FontSize', fontSize );
ylim([0,2]);
title('Subsys. 1 CLVF', 'Interpreter', 'latex', 'FontSize', titleSize );
grid off;
% s1.Position = [s1.Position(1), s1.Position(2)+0.025, s1.Position(3)*0.8, s1.Position(4)];


s2 = subplot(1,3,2);
set(gca,'Position', [ 0.4, 0.35, 0.2, 0.55]) % subplot 2

sub2 = visFuncIm(g_sub, sub2g1,'cyan',1);
set(gca ); % Make tick labels bold
set(gca,'yTick',[0:1:2]);
set(gca,'xTick',[-2:1:2]);
zx1 = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',zx1,'fontsize',25);
xlabel('$x_2$', 'Interpreter', 'latex', 'FontSize', fontSize );
ylabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex', 'FontSize', fontSize );
ylim([0,2]);
title('Subsys. 2 CLVF', 'Interpreter', 'latex', 'FontSize', titleSize );
grid off;
% s2.Position = [s2.Position(1), s2.Position(2)+0.025, s2.Position(3)*0.8, s2.Position(4)];



s3new = subplot(1,3,3);
set(gca,'Position', [ 0.7, 0.35, 0.2, 0.55]) % subplot 1

OriV = visFuncIm(g, full_g01,'red',0.5);
hold on;
ReconV = visFuncIm(g, recon_g01, 'blue', 0.5);
OriR = visSetIm(g, full_g01,'red',eps);
ReconR = visSetIm(g, recon_g01, 'blue', eps);
hold off;
view(30,20)
set(gca ); % Make tick labels bold
set(gca,'zTick',[0:1:2]);
set(gca,'yTick',[-2:2:2]);
set(gca,'xTick',[-2:2:2]);
zx1 = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',zx1,'fontsize',25);
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', fontSize );
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', fontSize );
zlabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex', 'FontSize', fontSize );
title('Recon v.s. Origin', 'Interpreter', 'latex', 'FontSize', titleSize );
grid off;
zlim([0,2]);
% s3.Position = [s3.Position(1), s3.Position(2), s3.Position(3)*0.8, s3.Position(4)];

lg1 = legend([OriV,ReconV,OriR,ReconR],...
    {'Orig. CLVF', 'Recon. CLVF', 'Orig. ROES', 'Recon. ROES'}, ...
    'Interpreter', 'latex', 'FontSize', 18 ,'Orientation','horizontal');


