function dx = dynamics(obj, ~, x, u, ~)

if iscell(x)
  dx = cell(obj.nx, 1);
  
  % Kinematic plane (speed can be changed instantly)
  dx{1} = x{2} + u{1};
  dx{2} = u{2};
else
  dx = zeros(obj.nx, 1);
  
  % Kinematic plane (speed can be changed instantly)
  dx(1) = x(2) + u(1);
  dx(2) = u(2);
end
end