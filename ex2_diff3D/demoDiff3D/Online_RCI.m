close all; 
clear; 
clc

% Problem setup
dt = 0.05;
sim_t = [0:dt:60];
delta = 1e-3;
num_traj = 3;
gamma = [0, 0.1, 0.2];

cost = 'full';

switch cost
    case 'recon'
        data = importdata('data_recon.mat');
        data1 = data.datag00;
        data2 = data.datag01;
        data3 = data.datag02;
    case 'full'
        data = importdata('full.mat');
        data1 = data.g0.data;
        data2 = data.g1.data;
        data3 = data.g2.data;
end

g = data.g;

t = 0;
  
x0 = [ -1; -1; 0.5];

x = nan(3,length(sim_t),num_traj);
u = nan(3,length(sim_t),num_traj);
V = nan(length(sim_t),num_traj);
u_delta = nan(4,length(sim_t),num_traj);

for i=1:4
    x(:,1,i) = x0;
end

Deriv_1 = computeGradients(g, data1);
Deriv_2 = computeGradients(g, data2);
Deriv_3 = computeGradients(g, data3);

Deriv = {Deriv_1, Deriv_2, Deriv_3};

Value = nan(g.N(1), g.N(2), g.N(3), num_traj);
grad = nan(g.N(1), g.N(2), g.N(3), 3, num_traj);

lb = nan(num_traj,3);
lb(:,1) = -1;
lb(:,2) = -1;
lb(:,2) = -0.5;
ub = -lb; %try 2x1

Value(:,:,:,1) = data1;
Value(:,:,:,2) = data2;
Value(:,:,:,3) = data3;

for k = 1:num_traj
    for r = 1:3
        grad(:,:,:,r,k) = Deriv{k}{r};
    end
end

%% QP control: setup with slack variable
H_delta = [ 0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, 0; 0, 0, 0, 2]; %?
f_delta = [0, 0, 0, 0]; %?

lb_delta = [-1; -1; -0.5; 0]; %?
ub_delta = [1; 1; 0.5; inf]; %?

H = eye(3);
f = [0;0;0];

options = optimoptions('quadprog', 'ConstraintTolerance', 1e-6, 'StepTolerance', 1e-12, 'Display','iter');

for j = 1:num_traj
    for i = 1 : length(sim_t)
        V(i,j) = eval_u(g,Value(:,:,:,j),x(:,i,j));
        deriv1 = eval_u(g,grad(:,:,:,1,j),x(:,i,j));
        deriv2 = eval_u(g,grad(:,:,:,2,j),x(:,i,j));
        deriv3 = eval_u(g,grad(:,:,:,3,j),x(:,i,j));

        Lg1V = deriv1;
        Lg2V = deriv2;
        Lg3V = deriv3;

        LfV = deriv1*x(3,i,j) + deriv2*x(3,i,j);
        A_delta = [ Lg1V, Lg2V, Lg3V, -1 ; 0, 0, 0, -1 ];
        b_delta = [ -LfV-gamma(j)*V(i,j); 0];
        [u_delta(:,i,j),~,~] = quadprog(H_delta,f_delta,A_delta,b_delta,[],[],lb_delta,ub_delta);
% 
        A = [Lg1V, Lg2V, Lg3V];
        b = -LfV - gamma(j)*V(i,j) + u_delta(4,i,j); 
        [u(:,i,j),~,flag] = quadprog(H,f,A,b,[],[],lb,ub);

        [ts_temp, xs_temp] = ode45(@(t,y) linear3D(t,y,u(:,i,j)), [t t+dt], x(:,i,j));
        x(:,i+1,j) = xs_temp(end,:);
        t = t+dt;
    end
end


full_qp.valfunc = V;
full_qp.traj = x;
full_qp.ctrl = u;
full_qp.vio = u_delta;
full_qp.t = sim_t;
full_qp.num_traj = num_traj;
full_qp.dt = dt;
save('full_qp','full_qp')


figure
plot(sim_t(1:length(V)),V)
grid on
xlabel('t')
ylabel('Value')
legend('0.0','0.1','0.2','0.3')
title('Value Function Trajectory')

figure; % Create a new figure
hold on; % Hold on to the current plot
for j = 1:num_traj
    plot3(x(1,:,j), x(2,:,j), x(3,:,j)) % Plot each trajectory
end
view(40,25)
grid on;
xlabel('x1');
ylabel('x2');
zlabel('x3');
title('State Trajectory');
legend('0.0', '0.1', '0.2', '0.3', 'Location', 'best');
hold off;

figure
for j = 1:num_traj
    subplot(3,1,j)
    plot(sim_t(1:length(u)),u(:,j))
    grid on
    xlabel('t')
    ylabel('control input')
    title('Control Sequence')
end

%%
function dydt = linear3D(t,s,u)
    dydt = [s(3)+u(1); s(3)+u(2); u(3)];
end