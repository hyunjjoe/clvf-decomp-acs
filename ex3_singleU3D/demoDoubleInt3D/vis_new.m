close all
clear 
clc
% Define a variable for font size
% fontSize = 27.5;
%Load Value Function
recon = importdata('data_recon.mat');
recon_g01 = recon.datag00;
traj = importdata('traj.mat');

grid_min = [-2; -2; -2]; % Lower corner of computation domain
grid_max = [2; 2; 2];    % Upper corner of computation domain
N = [101; 101; 101];         % Number of grid points per dimension
g = createGrid(grid_min, grid_max, N);

[g2d, recon1_2d] = proj(g, recon_g01, [0,0,1],'min');

S_gamma = importdata('S_gamma.mat');
S_gamma_end = importdata('S_gamma_end.mat');

%%
%Visualize Value Function
figure
set(gcf,'unit','normalized','position',[0.2,0.2,0.6,0.65]);

subplot(2,2,1)
set(gca,'Position', [ 0.1, 0.6, 0.35, 0.3]) % subplot 1

sg=visSetIm(g, recon_g01, 'g', S_gamma.level);
hold on
ex=plot3(S_gamma.ex(:,1),S_gamma.ex(:,2),S_gamma.ex(:,3),'k*');
view(30,20)
xlim([-2,2])
ylim([-2,2])
zlim([-2,2])
% set(gca ); % Make tick labels bold
set(gca,'zTick',[-2:2:2]);
set(gca,'yTick',[-2:2:2]);
set(gca,'xTick',[-2:2:2]);
zx1 = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',zx1,'fontsize',25);
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 25 );
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 25 );
zlabel('$x_3$', 'Interpreter', 'latex', 'FontSize', 25 );
title('$ \mathcal S_\gamma$', 'Interpreter', 'latex', 'FontSize', 20 );

subplot(2,2,2)
set(gca,'Position', [ 0.55, 0.6, 0.35, 0.3]) % subplot 1

visSetIm(g, recon_g01, 'g', S_gamma_end.level);
hold on
plot3(S_gamma_end.ex(:,1),S_gamma_end.ex(:,2),S_gamma_end.ex(:,3),'k*');
view(30,20)
xlim([-2,2])
ylim([-2,2])
zlim([-2,2])
% set(gca ); % Make tick labels bold
set(gca,'zTick',[-2:2:2]);
set(gca,'yTick',[-2:2:2]);
set(gca,'xTick',[-2:2:2]);
zx1 = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',zx1,'fontsize',25);
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 25 );
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 25 );
zlabel('$x_3$', 'Interpreter', 'latex', 'FontSize', 25 );
title('$\bar {\mathcal S}_\gamma$', 'Interpreter', 'latex', 'FontSize', 20 );

subplot(2,2,3)
set(gca,'Position', [ 0.1, 0.15, 0.35, 0.3]) % subplot 1
tj = plot3(traj.x(1,:), traj.x(2,:),traj.x(3,:),'lineWidth',1.5,'color','b','lineStyle','--');
hold on;
or = plot3(0,0,0,'ro','lineWidth', 2,'MarkerSize',10,'MarkerFaceColor','r');
hold on
ic = plot3(traj.x(1,1), traj.x(2,1),traj.x(3,1),'ms','MarkerSize',10, ...
    'lineWidth',2,'MarkerFaceColor','m')
view(40,20)
xlim([-0.5,1])
ylim([-0.5,1])
zlim([-0.5,0.5])
% set(gca ); % Make tick labels bold
set(gca,'zTick',[-0.5:0.5:0.5]);
set(gca,'yTick',[-0.5:1:1]);
set(gca,'xTick',[-0.5:1:1]);
zx1 = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',zx1,'fontsize',25);
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', 25 );
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', 25 );
zlabel('$x_3$', 'Interpreter', 'latex', 'FontSize', 25 );
title('Optimal Traj', 'Interpreter', 'latex', 'FontSize', 20 );

% eps = 1.3;
subplot(2,2,4)
set(gca,'Position', [ 0.55, 0.15, 0.35, 0.3]) % subplot 1

val = plot( traj.t , traj.V,'b','linewidth',1.5);

hold off;
xlim([0,18])
ylim([0,2])
% set(gca ); % Make tick labels bold
set(gca,'yTick',[0:1:2]);
set(gca,'xTick',[0:5:15]);
zx1 = get(gca,'ZTickLabel'); 
set(gca,'ZTickLabel',zx1,'fontsize',25);
lg1 = legend([sg,ex,or,ic],{'$\mathcal S_\gamma$','Empty ACS','Origin','Initial State'}, 'Interpreter', 'latex', 'FontSize', 18 ,...
    'orientation','horizontal');

xlabel('$t$', 'Interpreter', 'latex', 'FontSize', 25 );
ylabel('$\bar V^\infty_\gamma(t)$', 'Interpreter', 'latex', 'FontSize', 25 );
title('Value along Traj', 'Interpreter', 'latex', 'FontSize', 20 );