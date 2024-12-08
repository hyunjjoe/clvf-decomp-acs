function [u_ad_min, u_ad_max, grad1, grad2] = recon_admis(yLast, y, schemeData, t, deltaT)
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
  dynSys = schemeData.dynSys;
  gamma = schemeData.clf.gamma;
  u = dynSys.uRange;
  grid = schemeData.grid;
  conv = 0.015;
  data = reshape(y,grid.shape);
  dataLast = reshape(yLast,grid.shape);
  fprintf('the deltaT is %f', deltaT)

  deriv = computeGradients(grid, dataLast);

  uOpt = dynSys.optCtrl(t, grid.xs, deriv, schemeData.uMode);
  dx = dynSys.dynamics(t, grid.xs, uOpt, []);
%% Initialize the admissible control set for this subsystem
  u_ad_min = zeros(grid.shape);
  u_ad_max = zeros(grid.shape);
  i = 1:numel(data);
%% Except the Case where deriv{2} == 0
  i_0 = find(deriv{2} == 0);
  ind_0 = intersect(i_0, i);
  u_ad_min(ind_0) = u(1);
  u_ad_max(ind_0) = u(2);
    
%% Apply computation based on the policy
    
  i_p = intersect(find(deriv{2}> 0),i);
  i_n = intersect(find(deriv{2}< 0),i);
        
  u_ad_min(i) = uOpt(i);
  u_ad_max(i) = uOpt(i);
  u_ad_min(ind_0) = u(1);
  u_ad_max(ind_0) = u(2);
  u_ad_max(i_p) = max(min((-conv-(gamma*dataLast(i_p)) - deriv{1}(i_p).*dx{1}(i_p).*deltaT)./(deriv{2}(i_p).*deltaT), u(2)), u(1));
  u_ad_min(i_n) = min(max((-conv-(gamma*dataLast(i_n)) - deriv{1}(i_n).*dx{1}(i_n).*deltaT)./(deriv{2}(i_n).*deltaT), u(1)), u(2));
      

  u_ad_max(u_ad_max<u_ad_min) = uOpt(u_ad_max<u_ad_min);
  u_ad_min(u_ad_max<u_ad_min) = uOpt(u_ad_max<u_ad_min);

grad1 = deriv{1};
grad2 = deriv{2};
  
end