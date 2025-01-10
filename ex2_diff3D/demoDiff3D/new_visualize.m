close all
clear 
clc
% Define a variable for font size
% fontSize = 27.5;
%Load Value Function
recon = importdata("data_recon.mat");
recon_g01 = recon.datag00;

full = importdata("full.mat");
full_g01 = full.g0.data;
g = full.g;

[g2d, recon1_2d] = proj(g, recon_g01, [0,0,1],'min');
[~, full1_2d] = proj(g, full_g01, [0,0,1], 'min');

S_gamma = importdata('S_gamma.mat');

%%
%Visualize Value Function
figure
set(gcf,'unit','normalized','position',[0.2,0.2,0.6,0.6]);

subplot(1,4,1)
% set(gca,'Position', [ 0.1, 0.6, 0.3, 0.3]) % subplot 1

sg=visSetIm(g, recon_g01, 'g', S_gamma.level);
hold on
ex=plot3(S_gamma.ex(:,1),S_gamma.ex(:,2),S_gamma.ex(:,3),'k*');
view(30,20)
xlim([-2,2])
ylim([-2,2])
zlim([-2,2])
% set(gca, 'FontWeight', 'bold'); % Make tick labels bold
set(gca,'zTick',[-2:2:2]);
set(gca,'yTick',[-2:2:2]);
set(gca,'xTick',[-2:2:2]);
zx1 = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',zx1,'fontsize',25);
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 25);
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 25);
zlabel('$x_3$', 'Interpreter', 'latex', 'FontSize', 25);
title('$S_\gamma$', 'Interpreter', 'latex', 'FontSize', 20);
%lg0 = legend('True CLVF', 'Interpreter', 'latex', 'FontSize', 20);

subplot(1,4,2)
% set(gca,'Position', [ 0.5, 0.6, 0.3, 0.3]) % subplot 1

visFuncIm(g2d, full1_2d,'red',0.5);
hold on;
visFuncIm(g2d, recon1_2d, 'blue', 0.5);
hold off;
view(40,20)
% set(gca, 'FontWeight', 'bold'); % Make tick labels bold
zlim([0,3]);
xlim([-1.4,1.4]);
ylim([-1.4,1.4]);

set(gca,'zTick',[0:2:3]);
set(gca,'yTick',[-1:2:1]);
set(gca,'xTick',[-1:2:1]);
zx1 = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',zx1,'fontsize',25);
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 25);
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 25);
zlabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex', 'FontSize', 25);
title('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex', 'FontSize', 20);
grid off;

eps = 0.8;


subplot(1,4,3)
% set(gca,'Position', [ 0.1, 0.1, 0.3, 0.3]) % subplot 1

full = visSetIm(g, full_g01,'red',eps);
hold on;
reco = visSetIm(g, recon_g01, 'blue', eps);
hold off;
view(40,20)
xlim([-2,2])
ylim([-2,2])
zlim([-2,2])
% set(gca, 'FontWeight', 'bold'); % Make tick labels bold
set(gca,'zTick',[-2:2:2]);
set(gca,'yTick',[-2:2:2]);
set(gca,'xTick',[-2:2:2]);
zx1 = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',zx1,'fontsize',25);
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 25);
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 25);
zlabel('$x_3$', 'Interpreter', 'latex', 'FontSize', 25);
title('$V^{\infty}_{\gamma} = 0.8$ level set', 'Interpreter', 'latex', 'FontSize', 20);
lg1 = legend([sg,ex,full,reco],{'$\mathcal S_\gamma$','Empty ACSS','Orig. CLVF', 'Recon. CLVF'}, 'Interpreter', 'latex', 'FontSize', 18 );

eps = 1.3;
subplot(1,4,4)
% set(gca,'Position', [ 0.5, 0.1, 0.3, 0.3]) % subplot 1

visSetIm(g, full_g01,'red',eps);
hold on;
visSetIm(g, recon_g01, 'blue', eps);
hold off;
view(40,20)
xlim([-2,2])
ylim([-2,2])
zlim([-2,2])
% set(gca, 'FontWeight', 'bold'); % Make tick labels bold
set(gca,'zTick',[-2:2:2]);
set(gca,'yTick',[-2:2:2]);
set(gca,'xTick',[-2:2:2]);
zx1 = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',zx1,'fontsize',25);
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 25);
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 25 );
zlabel('$x_3$', 'Interpreter', 'latex', 'FontSize', 25 );
title('$V^{\infty}_{\gamma} = 1.3$ level set', 'Interpreter', 'latex', 'FontSize', 20 )