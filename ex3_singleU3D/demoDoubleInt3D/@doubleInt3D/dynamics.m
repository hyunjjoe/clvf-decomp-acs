function dx = dynamics(obj, ~, x, u, ~)

if iscell(x)
  dx = cell(obj.nx, 1);

  for i = 1:length(obj.dims)
    dx{i} = dynamics_cell_helper(obj, x, u, [], obj.dims, obj.dims(i));
  end
  % Kinematic plane (speed can be changed instantly)
  %{
  dx{1} = x{3};
  dx{2} = x{3};
  dx{3} = u;
  %}
else
  if size(x) == 3
    dx = zeros(obj.nx, 1);
  
    % Kinematic plane (speed can be changed instantly)
    dx(1) = x(3);
    dx(2) = x(3);
    dx(3) = u;
  end
  dx = zeros(size(x));
  
  dx(:,1) = x(:,3);
  dx(:,2) = x(:,3);
  dx(:,3) = u;
end
end

function dx = dynamics_cell_helper(obj, x, u, d, dims, dim)

switch dim
  case 1
    dx = x{dims==3};
  case 2
    dx = x{dims==3};
  case 3
    dx = u;
  otherwise
    error('Only dimension 1-3 are defined for dynamics of DubinsCar!')
end
end