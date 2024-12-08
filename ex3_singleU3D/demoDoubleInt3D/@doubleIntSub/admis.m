function [u_ad_min, u_ad_max] = admis(obj, yLast, y, schemeData, conv, deltaT)
%       [u_ad_min, u_ad_max] = admis(obj, y, schemeData, t, deltaT)
% Calculate the admissible control for BRS in particular one time step
%       * This process is for Dubins Car *
%       subsystem 1: doty = v*sin(theta)
%                    dottheta = w = u           u\in[umin, umax]
% Case 1:
%       minimal bound (umin_2): uOpt
%       maximal bound (umax_2): 0 = V(x,T) + [(Vy)*doty + (Vtheta)*dottheta] * deltaT
%                               dottheta = [-V(x,T)/deltaT - (Vy)*doty]/(Vtheta)   
%   u_admis = [u_ad_min, u_ad_max] = [umin, umax] \intersect [umin_2, umax_2]
%
% Case 2:
%       maximal bound (umax_2): uOpt
%       minimal bound (umin_2): 0 = V(x,T) + [(Vy)*doty + (Vtheta)*dottheta] * deltaT
%                               dottheta = [-V(x,T)/deltaT - (Vy)*doty]/(Vtheta) 
%   u_admis = [u_ad_min, u_ad_max] = [umin, umax] \intersect [umin_2, umax_2]
%       
% Use the information in [1.schemeData & 2.deriv] to decide which computation case to use
%       if Enforcable and deriv{2}>0: Case 1
%          Enforcable and deriv{2}<0: Case 2
%
%       if Inevitable and deriv{2}>0: Case 2
%          Inevitable and deriv{2}<0: Case 1
%
%% Extract the useful information
  digits(4);

  dynSys = schemeData.dynSys;
  gamma = schemeData.clf.gamma;
  u = dynSys.uRange;
  grid = schemeData.grid;
  data = reshape(y,grid.shape);
  dataLast = reshape(yLast,grid.shape);
  deriv = computeGradients(grid, dataLast);

  uOpt = dynSys.optCtrl(NaN, grid.xs, deriv, schemeData.uMode);
  dx = dynSys.dynamics(NaN, grid.xs, uOpt);
%% Initialize the admissible control set for this subsystem
  u_ad_min = zeros(size(data));
  u_ad_max = zeros(size(data));
  i = 1:numel(data);

%% Except the case where deriv{2} == 0
  i_0 = find(deriv{2} == 0);
  ind_0 = intersect(i_0, i);
  u_ad_min(ind_0) = u(1);
  u_ad_max(ind_0) = u(2);
    
%% Apply computation based on the policy
  policy = zeros(size(data));
  i_p = find(deriv{2}>0);
  i_n = find(deriv{2}<0);
  policy(i_p) = 1;
  policy(i_n) = 2;

  i_1 = find(policy == 1);
  i_2 = find(policy == 2);
  ind_1 = intersect(i_1, i);
  ind_2 = intersect(i_2, i);
  u_ad_min(ind_1) = uOpt(ind_1);
  u_ad_max(ind_2) = uOpt(ind_2);

  
  u_ad_max(ind_1) = max(min((conv-(gamma*dataLast(ind_1)) - deriv{1}(ind_1).*dx{1}(ind_1).*deltaT)./(deriv{2}(ind_1).*deltaT), u(2)), u(1));
  u_ad_min(ind_2) = min(max((conv-(gamma*dataLast(ind_2)) - deriv{1}(ind_2).*dx{1}(ind_2).*deltaT)./(deriv{2}(ind_2).*deltaT), u(1)), u(2));
  %u_ad_max(ind_1) = min((-conv-(gamma*dataLast(ind_1)) - deriv{1}(ind_1).*dx{1}(ind_1).*deltaT)./(deriv{2}(ind_1).*deltaT), u(2));
  %u_ad_min(ind_2) = max((-conv-(gamma*dataLast(ind_2)) - deriv{1}(ind_2).*dx{1}(ind_2).*deltaT)./(deriv{2}(ind_2).*deltaT), u(1));

  u_ad_max(u_ad_max<u_ad_min) = uOpt(u_ad_max<u_ad_min);
  u_ad_min(u_ad_max<u_ad_min) = uOpt(u_ad_max<u_ad_min);

grad1 = deriv{1};
grad2 = deriv{2};
  
end