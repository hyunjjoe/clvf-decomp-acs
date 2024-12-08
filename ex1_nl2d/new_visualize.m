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

[JI0, FI0, FE0] = jaccard(g,full_g00,recon_g00);
[JI1, FI1, FE1] = jaccard(g,full_g01,recon_g01);
[JI2, FI2, FE2] = jaccard(g,full_g03,recon_g03);
[JI3, FI3, FE3] = jaccard(g,full_g05,recon_g05);

eps = 2;

%Visualize Value Function
figure
set(gcf,'unit','normalized','position',[0.2,0.2,0.6,0.6]);

s1 = subplot(2,2,1);
visFuncIm(g, full_g01,'red',0.5);
hold on;
visFuncIm(g, recon_g01, 'blue', 0.5);
visSetIm(g, full_g01,'red',eps);
visSetIm(g, recon_g01, 'blue', eps);
hold off;
view(30,20)
set(gca  ); % Make tick labels bold
set(gca,'zTick',[0:1:2]);
set(gca,'yTick',[-2:2:2]);
set(gca,'xTick',[-2:2:2]);
zx1 = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',zx1,'fontsize',25);
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', fontSize  );
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', fontSize  );
zlabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex', 'FontSize', fontSize  );
title('$\gamma = 0.1$', 'Interpreter', 'latex', 'FontSize', titleSize  );
grid off;
zlim([0,2]);
s1.Position = [s1.Position(1), s1.Position(2), s1.Position(3)*0.8, s1.Position(4)];
lg1 = legend('True CLVF', 'Recon. CLVF', 'True ROES', 'Recon. ROES', 'Interpreter', 'latex', 'FontSize', 20);


s2 = subplot(2,2,2);
visFuncIm(g, full_g03,'red',0.5);
hold on;
visFuncIm(g, recon_g03, 'blue', 0.5);
visSetIm(g, full_g03,'red',eps);
visSetIm(g, recon_g03, 'blue', eps);
hold off;
view(30,20)
set(gca  ); % Make tick labels bold
set(gca,'zTick',[0:1:2]);
set(gca,'yTick',[-2:2:2]);
set(gca,'xTick',[-2:2:2]);
zx1 = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',zx1,'fontsize',25);
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', fontSize  );
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', fontSize  );
zlabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex', 'FontSize', fontSize  );
title('$\gamma = 0.3$', 'Interpreter', 'latex', 'FontSize', titleSize  );
grid off;
zlim([0,2]);
s2.Position = [s2.Position(1), s2.Position(2), s2.Position(3)*0.8, s2.Position(4)];

%Load QP
sub_qp = importdata("sub_qp.mat");
full_qp = importdata("full_qp.mat");

v_sub = sub_qp.valfunc;
v_full = full_qp.valfunc;

x_sub = sub_qp.traj;
x_full = full_qp.traj;

dt = sub_qp.dt;
sim_t = sub_qp.t;

%Visualize QP
s3 = subplot(2,2,3);
hold on
plot(x_sub(1,1:900,2), x_sub(2,1:900,2), 'Color', 'green','LineWidth', 2);
plot(x_sub(1,1:240,3), x_sub(2,1:240,3), 'Color',  [1, 0.25, 0],'LineWidth', 2);
scatter(-1, -0.5, 25, 'MarkerEdgeColor', 'magenta', 'MarkerFaceColor', 'white', 'LineWidth', 1.5);
scatter(0, 0, 25, 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'white', 'LineWidth', 1.5);
hold off
set(gca  ); % Make tick labels bold
zx1 = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',zx1,'fontsize',25);
set(gca,'yTick',[-1:1:1]);
set(gca,'xTick',[-1:1:1]);
xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', fontSize  );
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', fontSize  );
title('State Trajectory (Recon.)', 'Interpreter', 'latex', 'FontSize', titleSize  );
xlim([-1.25,1.25]);
ylim([-1,1]);
s3.Position = [s3.Position(1), s3.Position(2), s3.Position(3)*0.8, s3.Position(4)];

lg2 = legend('$\gamma = 0.1$', '$\gamma = 0.3$', 'Initial State', 'Origin', 'Interpreter', 'latex', 'FontSize', 20);

s4 = subplot(2,2,4);
hold on
plot(sim_t,v_sub(:,2), 'Color', 'green','LineWidth', 2);
plot(sim_t,v_sub(:,3), 'Color',  [1, 0.25, 0],'LineWidth', 2);
hold off
set(gca  ); % Make tick labels bold
zx1 = get(gca,'ZTickLabel');
set(gca,'ZTickLabel',zx1,'fontsize',25);
set(gca,'yTick',[0:0.5:1]);
set(gca,'xTick',[0:30:60]);
xlabel('$t$', 'Interpreter', 'latex', 'FontSize', fontSize  );
ylabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex', 'FontSize', fontSize  );
title('Value Evolution (Recon.)', 'Interpreter', 'latex', 'FontSize', titleSize);
s4.Position = [s4.Position(1), s4.Position(2), s4.Position(3)*0.8, s4.Position(4)];
