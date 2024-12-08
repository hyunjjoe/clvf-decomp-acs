close all
clear 
clc

%Load Value Function
recon = importdata("data_recon.mat");
recon_g00 = recon.datag00;
subg = recon.g;
% recon_g01 = recon.datag01;
%recon_g02 = recon.datag02;

full = importdata("full.mat");
full_g00 = full.g0.data;
% full_g01 = full.g1.data;
%full_g02 = full.g2.data;
g = full.g;

[subg2d, recon1_2d] = proj(subg, recon_g00, [1,0,0],'min');
% [~, recon2_2d] = proj(g, recon_g01, [0,0,1],'min');
%[~, recon3_2d] = proj(g, recon_g02, [0,0,1],'min');

[g2d, full1_2d] = proj(g, full_g00, [1,0,0], 'min');
% [~, full2_2d] = proj(g, full_g01, [0,0,1], 'min');
%[~, full3_2d] = proj(g, full_g02, [0,0,1], 'min');

figure
% subplot(1,2,1)
visFuncIm(g2d, full1_2d,'red',0.5);
hold on;
visFuncIm(subg2d, recon1_2d, 'blue', 0.5);
hold off;
view(30,20)
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_2$', 'Interpreter', 'latex');
zlabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex');
zlim([0,3]);
title('Level Set, $\gamma = 0$', 'Interpreter', 'latex');
lg1 = legend('True CLVF', 'Recon. CLVF', 'Interpreter', 'latex', 'FontSize', 15);

% subplot(1,2,2)
% visFuncIm(g2d, full2_2d,'red',0.5);
% hold on;
% visFuncIm(subg2d, recon2_2d, 'blue', 0.5);
% hold off;
% view(30,20)
% xlabel('$x_1$', 'Interpreter', 'latex');
% ylabel('$x_2$', 'Interpreter', 'latex');
% zlabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex');
% zlim([0,3]);
% title('Level Set, $\gamma = 0.1$', 'Interpreter', 'latex');

%{
subplot(1,3,3)
visFuncIm(g2d, full3_2d,'red',0.5);
hold on;
visFuncIm(g2d, recon3_2d, 'blue', 0.5);
hold off;
view(30,20)
xlabel('$x_1$', 'Interpreter', 'latex');
ylabel('$x_2$', 'Interpreter', 'latex');
zlabel('$V^{\infty}_{\gamma}$', 'Interpreter', 'latex');
zlim([0,3]);
title('Level Set, $\gamma = 0.2$', 'Interpreter', 'latex');
%}