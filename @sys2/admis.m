function [u_ad_min, u_ad_max, grad1, grad2] = admis(obj, yLast, y, schemeData, t, deltaT)
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
  u = dynSys.wRange;
  grid = schemeData.grid;
  
  data = reshape(y,grid.shape);
  dataLast = reshape(yLast,grid.shape);

  if ~isfield(schemeData, 'dMode')
    schemeData.dMode = 'max';
  end
  fprintf('the deltaT is %f', deltaT)

%% Get upwinded and centered derivative approximations.
%   derivL = cell(grid.dim, 1);
%   derivR = cell(grid.dim, 1);
%   derivC = cell(grid.dim, 1);
%  
%   for i = 1 : grid.dim
%     [ derivL{i}, derivR{i} ] = feval(schemeData.derivFunc, grid, dataLast, i);
%     derivC{i} = 0.5 * (derivL{i} + derivR{i});
%   end
% 
%   deriv = derivC;
  deriv = computeGradients(grid, dataLast);

  uOpt = dynSys.optCtrl(t, grid.xs, deriv, schemeData.uMode);
  dOpt = dynSys.optDstb(t, grid.xs, deriv, schemeData.dMode);
  dx = dynSys.dynamics(t, grid.xs, uOpt, dOpt);
%% Initialize the admissible control set for this subsystem
  u_ad_min = zeros(grid.shape);
  u_ad_max = zeros(grid.shape);
%% Except the Case where deriv{2} == 0
  i_set = find(data<= 0);
  i_outset = find(data> 0);

%   i_0 = find(((0 <deriv{2}) & (deriv{2}  < 0)));
%   u_ad_min(i_0) = uOpt(i_0);
%   u_ad_max(i_0) = uOpt(i_0);


%% Apply computation based on the policy

  if schemeData.uMode == 'min'
      i_p = intersect(find(deriv{2}> 0),i_set);
      i_n = intersect(find(deriv{2}< 0),i_set);

      u_ad_min(i_set) = uOpt(i_set);
      u_ad_max(i_set) = uOpt(i_set);
    
      u_ad_max(i_p) = max(min((-0.04-dataLast(i_p) - deriv{1}(i_p).*dx{1}(i_p).*deltaT)./(deriv{2}(i_p).*deltaT), u(2)), u(1));
      u_ad_min(i_n) = min(max((-0.04-dataLast(i_n) - deriv{1}(i_n).*dx{1}(i_n).*deltaT)./(deriv{2}(i_n).*deltaT), u(1)), u(2));

  elseif schemeData.uMode == 'max'
%       u_ad_min(i_set) = u(1);
%       u_ad_max(i_set) = u(2);

      i_p = intersect(find(deriv{2}>0),i_outset);
      i_n = intersect(find(deriv{2}<0),i_outset);

      u_ad_min(i_outset) = uOpt(i_outset);
      u_ad_max(i_outset) = uOpt(i_outset);

      u_ad_min(i_p) = min(max((0.06-dataLast(i_p) - deriv{1}(i_p).*dx{1}(i_p).*deltaT)./(deriv{2}(i_p).*deltaT), u(1)), u(2));
      u_ad_max(i_n) = max(min((0.06-dataLast(i_n) - deriv{1}(i_n).*dx{1}(i_n).*deltaT)./(deriv{2}(i_n).*deltaT), u(2)), u(1));
    
  end

  u_ad_max(u_ad_max<u_ad_min) = uOpt(u_ad_max<u_ad_min);
  u_ad_min(u_ad_max<u_ad_min) = uOpt(u_ad_max<u_ad_min);

%   u_ad_min(u_ad_min==2) = uOpt(u_ad_min==2);
%   u_ad_min(u_ad_max==-2) = uOpt(u_ad_max==-2);
%   u_ad_max(u_ad_min==2) = uOpt(u_ad_min==2);
%   u_ad_max(u_ad_max==-2) = uOpt(u_ad_max==-2);

%   u_ad_min(u_ad_min==2) = u(1);
%   u_ad_min(u_ad_max==-2) = u(1);
%   u_ad_max(u_ad_min==2) = u(2);
%   u_ad_max(u_ad_max==-2) = u(2);
% %% Visualization -- for the subsystem of Dubins Car
%   h1 = surf(grid.xs{1}, grid.xs{2}, u_ad_min);
%   h1.EdgeColor = 'none';
%   h1.FaceColor = 'b';
%   h1.FaceAlpha = .5;
%   h1.FaceLighting = 'phong';
%   view(45,45);

%   h2 = surf(grid.xs{1}, grid.xs{2}, u_ad_max);
%   h2.EdgeColor = 'none';
%   h2.FaceColor = 'b';
%   h2.FaceAlpha = .5;
%   h2.FaceLighting = 'phong';
  
grad1 = deriv{1};
grad2 = deriv{2};

end