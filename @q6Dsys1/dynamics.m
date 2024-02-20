function dx = dynamics(obj, ~, x, u, ~)
if ~iscell(u)
  u = num2cell(u);
end

if iscell(x)
  dx = cell(obj.nx, 1);
  for i = 1:length(obj.dims)
        dx{i} = dynamics_cell_helper(obj, x, u, [], obj.dims, obj.dims(i));
  end
else
  if size(x) == 3
    dx = zeros(obj.nx, 1);
    
    dx(1) = x(2);
    dx(2) = obj.grav*(sin(x(3))./cos(x(3)));
    dx(3) = u(1);
  end
    dx = zeros(size(x));
  
    dx(:,1) = x(:,2);
    dx(:,2) = obj.grav*(sin(x(:,3))./cos(x(:,3)));
    dx(:,3) = u(1);
end    

end

function dx = dynamics_cell_helper(obj, x, u, ~, dims, dim)

switch dim
  case 1
    dx = x{dims==2};
  case 2
    dx = obj.grav * (sin(x{dims==3}))./((cos(x{dims==3})));
  case 3
    dx = u{1};
  otherwise
    error('Only dimension 1-3 are defined for the dynamics!')
end
end