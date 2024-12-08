function [u_ad_min, u_ad_max] = clvf_adms(data,datalast, schemeData, conv, dt)

dynSys = schemeData.dynSys;
gamma = schemeData.clf.gamma;
u = dynSys.uRange;
grid = schemeData.grid;

% sub = importdata('subsys.mat');
V = data;
Vlast = datalast;
dt = 0.1;

deriv = computeGradients(grid, V);
LfV = deriv{1}.*grid.xs{2};
LgV = deriv{2};
    
A = LgV;
if V == Vlast
    b = conv/dt - gamma*V - LfV;
else 
    b = ( Vlast-V)/dt - gamma*V - LfV;
end 
    sol = A.\b;

iz = find(abs(LgV) <= 1e-5);
ip = find(LgV > 1e-5);
in = find(LgV < -1e-5);


%% create arrays
u_ad_min = zeros(size(V));
u_ad_max = zeros(size(V));
% u_ad = cell(2,1);


%% solve for u_ad
% LgV = 0: u_adms = [u_min,u_max] 
u_ad_min(iz) = u(1);
u_ad_max(iz) = u(2);



% LgV > 0: u_adms = [u_min,sol] 
u_ad_min(ip) = u(1);
u_ad_max(ip) = max(u(1),min(u(2),sol(ip)));

% LgV < 0: u_adms = [sol,u_max] 
u_ad_max(in) = u(2);
u_ad_min(in) = min(u(2),max(u(1),sol(in)));


%% combine ACS
u_ad.min = u_ad_min;
u_ad.max = u_ad_max;
u_adms = combine_admis_clvf(u_ad, grid, u_ad, grid);

end
