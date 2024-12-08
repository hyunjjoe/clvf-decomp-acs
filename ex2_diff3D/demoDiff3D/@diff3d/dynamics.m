function dx = dynamics(obj, ~, x, u, ~)

if iscell(x)
  dx = cell(obj.nx, 1);
  
  % Kinematic plane (speed can be changed instantly)
  dx{1} = x{3} + u{1};
  dx{2} = x{3} + u{2};
  dx{3} = u{3};
else
  dx = zeros(size(x));
  
  % Kinematic plane (speed can be changed instantly)
  dx(:,1) = x(:,3) + u(:,1);
  dx(:,2) = x(:,3) + u(:,2);
  dx(:,3) = u(:,3);
end
end