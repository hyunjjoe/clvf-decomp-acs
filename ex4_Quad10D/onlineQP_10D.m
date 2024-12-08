close all; clear; clc

% Problem setup
dt = 0.05;
sim_t = [0:dt:21.5];
delta = 1e-3;

cost = 'infnorm';
switch cost
    case '2norm'
%         data1 = importdata('V_2norm.mat');
        data1X = importdata('XYdata/V01_2norm.mat');
        data1X = data1X - min(data1X,[],'all');
        data1Z = importdata('Zdata/V01_2norm.mat');
        data1Z = data1Z - min(data1Z,[],'all');
    case 'infnorm'
%         data1 = importdata('V_infnorm.mat');
%         data1 = importdata('V_infnorm_bad.mat');
        X = importdata('Xdata.mat');
        data1X = X.V;
        data1X = data1X - min(data1X,[],'all');

        g_X = X.g;
        p = X.p;
        Z = importdata('Zdata.mat');
        data1Z = Z.V;
        data1Z = data1Z - min(data1Z,[],'all');

        g_Z = Z.g;
    case 'qc'
%         data1 = importdata('V_Quacost.mat');
        data1 = importdata('V_Quacost_bad.mat');
end

%% Grid
% g_Z = importdata('Zdata/g01_2norm.mat');
% g_X = importdata('XYdata/g01_2norm.mat');

% p = importdata('XYdata/params.mat');
Deriv_X = computeGradients(g_X, data1X);
Deriv_Z = computeGradients(g_Z, data1Z);


t = 0;
x0 = [ 0.6; -0.5 ; 0.5 ; 0.3 ; 0.6; -0.5 ; 0.5 ; 0.3 ; 0.8; -0.2 ];
x = nan(10,length(sim_t));
u = nan(3,length(sim_t));
d = nan(3,length(sim_t));

u_delta = nan(2,length(sim_t));
x(:,1) = x0;

H_delta = [ 0 , 0 ; 0 , 1];
f_delta = [0,0];
lb_delta = [-1;0];
ub_delta = [1;inf];

lb_deltaX = [-pi/4;0];
ub_deltaX = [pi/4;inf];

H = 1;
fX = 0;
lbX = -pi/4;
ubX = pi/4;
fZ = 0;
lbZ = -1;
ubZ = 1;
gamma = 0.1;
options = optimoptions('quadprog', 'ConstraintTolerance', 1e-6, 'StepTolerance', 1e-12, 'Display','iter');


%% Setup without slack variable
for i = 1 : length(sim_t)
    VX(i) = eval_u(g_X,data1X,x(1:4,i));
    VY(i) = eval_u(g_X,data1X,x(5:8,i));
    VZ(i) = eval_u(g_Z,data1Z,x(9:10,i));
    V(i) = max(VX(i) , max( VY(i) , VZ(i)));
    %     if V(i) >= 0.05

    %%%%%%%%%%%%%% Z dim
    derivZ1 = eval_u(g_Z,Deriv_Z{1},x(9:10,i));
    derivZ2 = eval_u(g_Z,Deriv_Z{2},x(9:10,i));

  
    Lg1VZ = derivZ2*1;
    LfVZ = derivZ1*x(10,i) - derivZ2*0;

    A_deltaZ = [ Lg1VZ , -1 ; 0 , -1 ];
    b_deltaZ = [ -LfVZ-gamma*VZ(i) ; 0];
    [u_deltaZ(:,i),~,~] = quadprog(H_delta,f_delta,A_deltaZ,b_deltaZ,[],[],lb_delta,ub_delta);

    AZ = Lg1VZ;
    bZ = -LfVZ - gamma*VZ(i)+u_deltaZ(2,i); % The 0.01 here accounts for the
    %                                               convergence threshold of
    %                                               CLVF
    [u(3,i),~,~] = quadprog(H,fZ,AZ,bZ,[],[],lbZ,ubZ);
    %     else
    %         u(i) = 0;
    %     end

    %%%%%%%%%%%%%% X dim
    derivX1 = eval_u(g_X,Deriv_X{1},x(1:4,i));
    derivX2 = eval_u(g_X,Deriv_X{2},x(1:4,i));
    derivX3 = eval_u(g_X,Deriv_X{3},x(1:4,i));
    derivX4 = eval_u(g_X,Deriv_X{4},x(1:4,i));


    Lg1VX = derivX4*p.n0;
    LfVX = derivX1*x(2,i) + derivX2*p.g * tan(x(3,i))+...
        derivX3*(-p.d1*x(3,i)+x(4,i))+derivX4*(-p.d0)*x(3,i);

    A_deltaX = [ Lg1VX , -1 ; 0 , -1 ];
    b_deltaX = [ -LfVX-gamma*VX(i) ; 0];
    [u_deltaX(:,i),~,~] = quadprog(H_delta,f_delta,A_deltaX,b_deltaX,[],[],lb_deltaX,ub_deltaX);

    AX = Lg1VX;
    bX = -LfVX - gamma*VX(i)+u_deltaX(2,i); % The 0.01 here accounts for the
    %                                               convergence threshold of
    %                                               CLVF
    [u(1,i),~,~] = quadprog(H,fX,AX,bX,[],[],lbX,ubX);


%%%%%%%%%%%%%% X dim
    derivY1 = eval_u(g_X,Deriv_X{1},x(5:8,i));
    derivY2 = eval_u(g_X,Deriv_X{2},x(5:8,i));
    derivY3 = eval_u(g_X,Deriv_X{3},x(5:8,i));
    derivY4 = eval_u(g_X,Deriv_X{4},x(5:8,i));


    Lg1VY = derivY4*p.n0;
    LfVY = derivY1*x(6,i) + derivY2*p.g * tan(x(7,i))+...
        derivY3*(-p.d1*x(7,i)+x(8,i))+derivY4*(-p.d0)*x(7,i);

    A_deltaY = [ Lg1VY , -1 ; 0 , -1 ];
    b_deltaY = [ -LfVY-gamma*VY(i) ; 0];
    [u_deltaY(:,i),~,~] = quadprog(H_delta,f_delta,A_deltaY,b_deltaY,[],[],lb_deltaX,ub_deltaX);

    AY = Lg1VY;
    bY = -LfVY  - gamma*VY(i)+u_deltaY(2,i); % The 0.01 here accounts for the
    %                                               convergence threshold of
    %                                               CLVF
    [u(2,i),~,~] = quadprog(H,fX,AY,bY,[],[],lbX,ubX);

%%%%%%%%update Traj
    [ts_temp1, xs_temp1] = ode45(@(t,y) Dcar(t,y,u(:,i),p), [t t+dt], x(:,i));

    x(:,i+1) = xs_temp1(end,:);
    t = t+dt

end


%% Figures and Videos
l = length(V);
figure
plot3(x(1,:),x(5,:),x(9,:));
hold on
plot3(x(1,1),x(5,1),x(9,1),'b*');

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
d0 = p.d0;
d1 = p.d1;
g = p.g;
n0 = p.n0;
kT = 1;
dydt = [x(2); g*tan(x(3));...
    -d1*x(3)+x(4); -d0*x(3)+n0*u(1);...
    x(6); g*tan(x(7));...
    -d1*x(7)+x(8); -d0*x(7)+n0*u(2);...
    x(10); kT*u(3)];
end