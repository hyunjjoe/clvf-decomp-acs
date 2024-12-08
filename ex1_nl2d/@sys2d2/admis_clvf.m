function [u_ad_min, u_ad_max, grad1] = admis_clvf(obj, y, schemeData, conv, deltaT)
%       [u_ad_min, u_ad_max] = admis(obj, y, schemeData, t, deltaT)
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

  if ~isfield(schemeData, 'dMode')
    schemeData.dMode = 'max';
  end

  deriv = computeGradients(grid, data);

  uOpt = dynSys.optCtrl(NaN, grid.xs, deriv, schemeData.uMode);
  dOpt = dynSys.optDstb(NaN, grid.xs, deriv, schemeData.dMode);
  dx = dynSys.dynamics(NaN, grid.xs, uOpt, dOpt);
%% Initialize the admissible control set for this subsystem
  u_ad_min = zeros(grid.shape);
  u_ad_max = zeros(grid.shape);
  i = 1:numel(data);
%Equilibrium Point vs. Smallest control invariant set (Dubin's car)

%% Apply computation based on the policy
  i_p = intersect(find(deriv{1}> 0),i);
  i_n = intersect(find(deriv{1}< 0),i);
        
  u_ad_min(i) = uOpt(i);
  u_ad_max(i) = uOpt(i);
  
  u_ad_max(i_p) = max(min((-conv-(gamma*data(i_p)))./(deriv{1}(i_p).*deltaT), u(2)), u(1));
  u_ad_min(i_n) = min(max((-conv-(gamma*data(i_n)))./(deriv{1}(i_n).*deltaT), u(1)), u(2));

  u_ad_max(u_ad_max<u_ad_min) = uOpt(u_ad_max<u_ad_min);
  u_ad_min(u_ad_max<u_ad_min) = uOpt(u_ad_max<u_ad_min);

grad1 = deriv{1};

end