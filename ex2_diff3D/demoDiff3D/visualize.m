close all
clear 
clc

%Load Value Function
recon = importdata("data_recon.mat");
recon_g00 = recon.datag00;
recon_g01 = recon.datag01;
recon_g02 = recon.datag02;

full = importdata("full.mat");
full_g00 = full.g0.data;
full_g01 = full.g1.data;
full_g02 = full.g2.data;
g = full.g;

[g2d, recon1_2d] = proj(g, recon_g00, [0,0,1],'min');
[~, recon2_2d] = proj(g, recon_g01, [0,0,1],'min');
[~, recon3_2d] = proj(g, recon_g02, [0,0,1],'min');

[~, full1_2d] = proj(g, full_g00, [0,0,1], 'min');
[~, full2_2d] = proj(g, full_g01, [0,0,1], 'min');
[~, full3_2d] = proj(g, full_g02, [0,0,1], 'min');

[JI0, FI0, FE0] = jaccard(g,full_g00,recon_g00);
[JI1, FI1, FE1] = jaccard(g,full_g01,recon_g01);
[JI2, FI2, FE2] = jaccard(g,full_g02,recon_g02);


eps = 3;

%Visualize Value Function
figure
subplot(2,3,1)
visFuncIm(g2d, full1_2d,'red',0.5);
hold on;
visFuncIm(g2d, recon1_2d, 'blue', 0.5);
visFuncIm(g2d, recon1_2d-full1_2d, 'green', 0.5);
visSetIm(g2d, full1_2d,'red',eps);
visSetIm(g2d, recon1_2d, 'blue', eps);
hold off;
view(30,20)
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_2$', 'Interpreter', 'latex');
zlabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex');
zlim([0,3]);
title('Level Set, $\gamma = 0$', 'Interpreter', 'latex');

subplot(2,3,2)
visFuncIm(g2d, full2_2d,'red',0.5);
hold on;
visFuncIm(g2d, recon1_2d, 'blue', 0.5);
visFuncIm(g2d, recon1_2d-full2_2d, 'green', 0.5);
visSetIm(g2d, full2_2d,'red',eps);
visSetIm(g2d, recon1_2d, 'blue', eps);
hold off;
view(30,20)
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_2$', 'Interpreter', 'latex');
zlabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex');
zlim([0,3]);
title('Level Set, $\gamma = 0.1$', 'Interpreter', 'latex');

subplot(2,3,3)
visFuncIm(g2d, full2_2d,'red',0.5);
hold on;
visFuncIm(g2d, recon2_2d, 'blue', 0.5);
visFuncIm(g2d, recon2_2d-full2_2d, 'green', 0.5);
visSetIm(g2d, full2_2d,'red',eps);
visSetIm(g2d, recon2_2d, 'blue', eps);
hold off;
view(30,20)
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_2$', 'Interpreter', 'latex');
zlabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex');
zlim([0,3]);
title('Level Set, $\gamma = 0.2$', 'Interpreter', 'latex');
%{
subplot(2,4,4)
visFuncIm(g2d, full3_2d,'red',0.5);
hold on;
visFuncIm(g2d, recon3_2d, 'blue', 0.5);
visFuncIm(g2d, recon3_2d-full3_2d, 'green', 0.5);
visSetIm(g2d, full3_2d,'red',eps);
visSetIm(g2d, recon3_2d, 'blue', eps);
hold off;
view(30,20)
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_2$', 'Interpreter', 'latex');
zlabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex');
zlim([0,3]);
title('Level Set, $\gamma = 0.3$', 'Interpreter', 'latex');


%Load QP
sub_qp = importdata("recon_qp.mat");
full_qp = importdata("full_qp.mat");

v_sub = sub_qp.valfunc;
v_full = full_qp.valfunc;

x_sub = sub_qp.traj;
x_full = full_qp.traj;

dt = sub_qp.dt;
sim_t = sub_qp.t;

%Visualize QP
figure
subplot(2,4,1)
hold on
plot(x_sub(1,:,1), x_sub(3,:,1), 'Color', 'blue');
plot(x_full(1,:,1), x_full(3,:,1), 'Color', 'red');
hold off
grid on;
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_3$', 'Interpreter', 'latex');
title('State Trajectory, $\gamma = 0$', 'Interpreter', 'latex');

subplot(2,4,2)
hold on
plot(x_sub(1,:,2), x_sub(3,:,2), 'Color', 'blue');
plot(x_full(1,:,2), x_full(3,:,2), 'Color', 'red');
hold off
grid on;
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_3$', 'Interpreter', 'latex');
title('State Trajectory, $\gamma = 0.1$', 'Interpreter', 'latex');

subplot(2,4,3)
hold on
plot(x_sub(1,:,3), x_sub(3,:,3), 'Color', 'blue');
plot(x_full(1,:,3), x_full(3,:,3), 'Color', 'red');
hold off
grid on;
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_3$', 'Interpreter', 'latex');
title('State Trajectory, $\gamma = 0.2$', 'Interpreter', 'latex');

subplot(2,4,4)
hold on
plot(x_sub(1,:,4), x_sub(3,:,4), 'Color', 'blue');
plot(x_full(1,:,4), x_full(3,:,4), 'Color', 'red');
hold off
grid on;
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_3$', 'Interpreter', 'latex');
title('State Trajectory, $\gamma = 0.3$', 'Interpreter', 'latex');

subplot(2,4,5)
hold on
plot(sim_t,v_sub(:,1), 'Color', 'blue');
plot(sim_t,v_full(:,1), 'Color', 'red');
hold off
grid on
ylabel('$t$', 'Interpreter', 'latex');
ylabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex');
title('Value Function Trajectory, $\gamma = 0$', 'Interpreter', 'latex');


subplot(2,4,6)
hold on
plot(sim_t,v_sub(:,2), 'Color', 'blue');
plot(sim_t,v_full(:,2), 'Color', 'red');
hold off
grid on
ylabel('$t$', 'Interpreter', 'latex');
ylabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex');
title('Value Function Trajectory, $\gamma = 0.1$', 'Interpreter', 'latex');

subplot(2,4,7)
hold on
plot(sim_t,v_sub(:,3), 'Color', 'blue');
plot(sim_t,v_full(:,3), 'Color', 'red');
hold off
grid on
ylabel('$t$', 'Interpreter', 'latex');
ylabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex');
title('Value Function Trajectory, $\gamma = 0.2$', 'Interpreter', 'latex');

subplot(2,4,8)
hold on
plot(sim_t,v_sub(:,4), 'Color', 'blue');
plot(sim_t,v_full(:,4), 'Color', 'red');
hold off
grid on
ylabel('$t$', 'Interpreter', 'latex');
ylabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex');
title('Value Function Trajectory, $\gamma = 0.3$', 'Interpreter', 'latex');


figure;
subplot(2,2,1);
title('$\gamma = 0$', 'Interpreter', 'latex');
hold on;
visSetIm(g, full_g00,'red','min');
visSetIm(g, recon_g00,'blue','min');
hold off;

subplot(2,2,2);
title('$\gamma = 0.1$', 'Interpreter', 'latex');
hold on;
visSetIm(g, full_g01,'red','min');
visSetIm(g, recon_g01,'blue','min');
hold off;

subplot(2,2,3);
title('$\gamma = 0.2$', 'Interpreter', 'latex');
hold on;
visSetIm(g, full_g02,'red','min');
visSetIm(g, recon_g02,'blue','min');
hold off;
legend('full', 'recon');

subplot(2,2,4);
title('$\gamma = 0.3$', 'Interpreter', 'latex');
hold on;
visSetIm(g, full_g03,'red','min');
visSetIm(g, recon_g03,'blue','min');
hold off;
%}