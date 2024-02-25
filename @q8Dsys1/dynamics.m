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
  if size(x) == 4
    dx = zeros(obj.nx, 1);
    
    dx(1) = x(2);
    dx(2) = obj.grav*(tan(x(3)));
    dx(3) = -1*obj.d1*x(3) + x(4);
    dx(4) = -1*obj.d0*x(3) + obj.n0*u(1);
  end
    dx = zeros(size(x));
  
    dx(:,1) = x(:,2);
    dx(:,2) = obj.grav*(tan(x(:,3)));
    dx(:,3) = -1*obj.d1*x(:,3) + x(:,4);
    dx(:,4) = -1*obj.d0*x(:,3) + obj.n0*u(1);
end    

end

function dx = dynamics_cell_helper(obj, x, u, ~, dims, dim)

switch dim
  case 1
    dx = x{dims==2};
  case 2
    dx = obj.grav*tan(x{dims==3});
  case 3
    dx = -1*obj.d1*x{dims==3} + x{dims==4};
  case 4
    dx = -1*obj.d0*x{dims==3} + obj.n0*u{1};
  otherwise
    error('Only dimension 1-4 are defined for the dynamics!')
end
end