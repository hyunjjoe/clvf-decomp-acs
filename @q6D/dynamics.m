function dx = dynamics(obj, ~, x, u, ~)
if ~iscell(u)
  u = num2cell(u);
end

if ~iscell(d)
  d = num2cell(d);
end

if iscell(x)
  dx = cell(obj.nx, 1);
  for i = 1:length(obj.dims)
        dx{i} = dynamics_cell_helper(obj, x, u, d, obj.dims, obj.dims(i));
  end
else
  if size(x) == 6
    dx = zeros(obj.nx, 1);
    
    dx(1) = x(2);
    dx(2) = obj.grav*tan(x(3));
    dx(3) = u(1);
    dx(4) = x(5);
    dx(5) = obj.grav*tan(x(6));
    dx(6) = u(2);
  end
    dx = zeros(size(x));
  
    dx(:,1) = x(:,2);
    dx(:,2) = obj.grav*tan(x(:,3));
    dx(:,3) = u(1);
    dx(:,4) = x(:,5);
    dx(:,5) = obj.grav*tan(x(:,6));
    dx(:,6) = u(2);
end    

end

function dx = dynamics_cell_helper(obj, x, u, d, dims, dim)

switch dim
  case 1
    dx = x{dims==2};
  case 2
    dx = obj.grav * x{dims==3};
  case 3
    dx = u{1};
  case 4
    dx = x{dims==5};
  case 5
    dx = obj.grav * x{dims==6};
  case 6
    dx = u{2};
  otherwise
    error('Only dimension 1-6 are defined for the dynamics!')
end
end