close all; clear; clc

% Problem setup
dt = 0.05;
sim_t = [0:dt:30];
delta = 1e-3;

cost = 'infnorm';
switch cost
    case '2norm'
%         data1 = importdata('V_2norm.mat');
        data1 = importdata('Zdata/V01_2norm_WS.mat');
    case 'infnorm'
%         data1 = importdata('V_infnorm.mat');
        Z = importdata('Zdata.mat');
        data1 = Z.V;
        g = Z.g;
        p = Z.p;
        data1 = data1 - min(data1,[],'all');

    case 'qc'
%         data1 = importdata('V_Quacost.mat');
        data1 = importdata('V_Quacost_bad.mat');
end

%% Grid
% g = importdata('Zdata/g01_2norm.mat');
% p = importdata('Zdata/params.mat');
Deriv = computeGradients(g, data1);


t = 0;
x0 = [ 0.8; -0.2 ];
x = nan(2,length(sim_t));
u = nan(1,length(sim_t));
d = nan(1,length(sim_t));

u_delta = nan(2,length(sim_t));
x(:,1) = x0;

H_delta = [ 0 , 0 ; 0 , 1];
f_delta = [0,0];
lb_delta = [-1 ;0];
ub_delta = [1;inf];

H = 1;
f = -p.g/p.kT;
lb = -1;
ub = 1;
gamma = 0.1;
options = optimoptions('quadprog', 'ConstraintTolerance', 1e-6, 'StepTolerance', 1e-12, 'Display','iter');


%% Setup without slack variable
for i = 1 : length(sim_t) 
    V(i) = eval_u(g,data1,x(:,i));
%     if V(i) >= 0.05
        deriv1 = eval_u(g,Deriv{1},x(:,i));
        deriv2 = eval_u(g,Deriv{2},x(:,i));
        
        Lg1V = deriv2*p.kT;
        LfV = deriv1*x(2,i) - deriv2*p.g;

        A_delta = [ Lg1V , -1 ; 0 , -1 ];
        b_delta = [ -LfV-gamma*V(i) ; 0];
        [u_delta(:,i),~,~] = quadprog(H_delta,f_delta,A_delta,b_delta,[],[],lb_delta,ub_delta);

        A = Lg1V;
        b = -LfV  - gamma*V(i)+u_delta(2,i); % The 0.01 here accounts for the
        %                                               convergence threshold of
        %                                               CLVF
        [u(i),~,flag] = quadprog(H,f,A,b,[],[],lb,ub);
%     else 
%         u(i) = 0;
%     end
    [ts_temp1, xs_temp1] = ode45(@(t,y) Dcar(t,y,u(i),p), [t t+dt], x(:,i));

    x(:,i+1) = xs_temp1(end,:);
    t = t+dt

end


%% Figures and Videos
l = length(V);
figure
plot(x(1,:),x(2,:));
grid on
xlabel('x','interpreter','latex');
ylabel('y','interpreter','latex');
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
plot(sim_t(1:l),V(1:l))
grid on
xlabel('t','interpreter','latex')
ylabel('V','interpreter','latex')

%% Figures and Videos
MakeVideo = 0;
% Traj on value function

if MakeVideo == 1
figure
visFuncIm(g,data1,'b',0.6)
view(30,75)
set(gcf,'unit','normalized','position',[0.1,0.1,0.8,0.8]);
hold on
h_trajV = animatedline('Marker','o');


xlabel('x1')
ylabel('x2')
zlabel('value')
title('value function')
if MakeVideo==1
    v = VideoWriter('DubinsQP','MPEG-4');
    v.FrameRate = 30;
    open(v);
end

for i = 1: length(V) - 1

    addpoints(h_trajV,x(1,i),x(2,i),V(i));

    drawnow
    if MakeVideo == 1
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
end 
if MakeVideo == 1
    close(v);
end
else

end




%%
function dydt = Dcar(t,x,u,p)
g = p.g;
kT = p.kT;
dydt = [x(2); kT*u-g];
end