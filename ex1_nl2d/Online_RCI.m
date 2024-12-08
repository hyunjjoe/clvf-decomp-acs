close all; 
clear; 
clc

% Problem setup
dt = 0.05;
sim_t = [0:dt:60];
delta = 1e-3;
num_traj = 4;
gamma = [0, 0.1, 0.3, 0.5];

cost = 'recon';

switch cost
    case 'recon'
        data = importdata('data_recon.mat');
        data1 = data.datag00;
        data2 = data.datag01;
        data3 = data.datag03;
        data4 = data.datag05;
    case 'fullsys'
        data1 = importdata('data_full_g00_c0002.mat');
        data2 = importdata('data_full_g01_c0002.mat');
        data3 = importdata('data_full_g03_c0002.mat');
        data4 = importdata('data_full_g05_c0002.mat');
end

g = importdata('g_full.mat');

t = 0;
  
x0 = [-2; 0.5];

x = nan(2,length(sim_t),num_traj);
u = nan(2,length(sim_t),num_traj);
V = nan(length(sim_t),num_traj);
u_delta = nan(3,length(sim_t),num_traj);

for i=1:num_traj
    x(:,1,i) = x0;
end

Deriv_1 = computeGradients(g, data1);
Deriv_2 = computeGradients(g, data2);
Deriv_3 = computeGradients(g, data3);
Deriv_4 = computeGradients(g, data4);

Deriv = {Deriv_1, Deriv_2, Deriv_3, Deriv_4};

Value = nan(g.N(1), g.N(2), num_traj);
grad = nan(g.N(1), g.N(2), 2, num_traj);

lb = nan(num_traj,2);
lb(:,1) = -4;
lb(:,2) = -1;
ub = -lb; %try 2x1

Value(:,:,1) = data1;
Value(:,:,2) = data2;
Value(:,:,3) = data3;
Value(:,:,4) = data4;

for k = 1:num_traj
    for r = 1:2
        grad(:,:,r,k) = Deriv{k}{r};
    end
end

%% QP control: setup with slack variable
H_delta = [ 0, 0, 0; 0, 0, 0; 0, 0, 2]; %?
f_delta = [0, 0, 0]; %?
lb_delta = [-4; -1; 0]; %?
ub_delta = [4; 1; inf]; %?

H = eye(2);
f = [0;0];

options = optimoptions('quadprog', 'ConstraintTolerance', 1e-6, 'StepTolerance', 1e-12, 'Display','iter');

for j = 1:num_traj
    for i = 1 : length(sim_t)
        V(i,j) = eval_u(g,Value(:,:,j),x(:,i,j));
        deriv1 = eval_u(g,grad(:,:,1,j),x(:,i,j));
        deriv2 = eval_u(g,grad(:,:,2,j),x(:,i,j));

        Lg1V = deriv1;
        Lg2V = deriv2;

        LfV = deriv1*(x(1,i,j)^2) + deriv2*x(2,i,j);

        A_delta = [ Lg1V, Lg2V, -1 ; 0, 0, -1 ]; %?
        b_delta = [ -LfV-gamma(j)*V(i,j); 0]; %?
        [u_delta(:,i,j),~,~] = quadprog(H_delta,f_delta,A_delta,b_delta,[],[],lb_delta,ub_delta);
% 
        A = [Lg1V, Lg2V];
        b = -LfV - gamma(j)*V(i,j) + u_delta(3,i,j);
        [u(:,i,j),~,flag] = quadprog(H,f,A,b,[],[],lb,ub);

        [ts_temp, xs_temp] = ode45(@(t,y) nl2D(t,y,u(:,i,j)), [t t+dt], x(:,i,j));
        x(:,i+1,j) = xs_temp(end,:);
        t = t+dt;
    end
end

%{
%% Figures 
l = length(V);
figure
plot3(x(1,:),x(2,:),x(3,:));
view(40,25)
[g1d, data1d] = proj(g,data1,[0,0,1],'min');
%visSetIm(g1d,data1d,'c',0.1)

xlabel('x1','interpreter','latex');
ylabel('x2','interpreter','latex');
zlabel('x3','interpreter','latex');

% 
% figure
% subplot(3,1,1)
% plot(sim_t(1:l),u(1:l))
% grid on
% xlabel('time')
% ylabel('control')
% 
% subplot(3,1,2)
% plot(sim_t(1:l),u_delta(2,1:l))
% grid on
% xlabel('time')
% ylabel('violation')
% 
% subplot(3,1,3)
% plot(sim_t(1:l),V(1:l))
% grid on
% xlabel('time')
% ylabel('Value')
% 
figure
set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.4]);

subplot(1,2,1)
plot(sim_t(1:l),V(1:l))
grid on
xlabel('t','interpreter','latex')
ylabel('V','interpreter','latex')

subplot(1,2,2)
plot(sim_t(1:l),u(1:l))
grid on
xlabel('t','interpreter','latex')
ylabel('u','interpreter','latex')
% 
%%

%% Videos
% MakeVideo = 0;
% [g1D, data1D] = proj(g,data1,[0 0 1],'min');
% % Traj on value function
% figure
% % visSetIm(g,data1,'c',0.01)
% visFuncIm(g1D,data1D,'c',0.6)
% view(40,25)
% set(gcf,'unit','normalized','position',[0.1,0.1,0.8,0.8]);
% hold on
% h_trajV = animatedline('Marker','o');
% 
% 
% xlabel('x1')
% ylabel('x2')
% zlabel('\theta')
% title('value function')
% if MakeVideo==1
%     v = VideoWriter('DubinsQP','MPEG-4');
%     v.FrameRate = 30;
%     open(v);
% end
% 
% for i = 1: length(V) - 1
%     addpoints(h_trajV,x(1,i),x(2,i),V(i));
%     drawnow
%     if MakeVideo == 1
%         frame = getframe(gcf);
%         writeVideo(v,frame);
%     end
% end 
% if MakeVideo == 1
%     close(v);
% end
% 
% 
%}
full_qp.valfunc = V;
full_qp.traj = x;
full_qp.ctrl = u;
full_qp.vio = u_delta;
full_qp.t = sim_t;
full_qp.num_traj = num_traj;
full_qp.dt = dt;
%save('sub_qp','full_qp')


figure
plot(sim_t(1:length(V)),V)
grid on
xlabel('t')
ylabel('Value')
legend('0.0','0.1','0.3','0.5')
title('Value Function Trajectory')

figure; % Create a new figure
hold on; % Hold on to the current plot
for j = 1:num_traj
    plot(x(1,:,j), x(2,:,j)) % Plot each trajectory
end

grid on;
xlabel('x1');
ylabel('x2');

title('State Trajectory');
legend('0.0', '0.1', '0.3','0.5', 'Location', 'best');
hold off;

figure
for j = 1:num_traj
    subplot(4,1,j)
    plot(sim_t(1:length(u)),u(:,j))
    grid on
    xlabel('t')
    ylabel('control input')
    title('Control Sequence')
end

%%
function dydt = nl2D(t,s,u)
    dydt = [(s(1)^2) + u(1); s(2) + u(2)];
end