function dx = dynamics(obj, ~, x, u, d)
if nargin < 5
  d = [0; 0];
end

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
  if size(x) == 2
    dx = zeros(obj.nx, 1);
    
    dx(1) = x(1).^2 + u(1);
    dx(2) = x(2) + u(2);
  end
    dx = zeros(size(x));
  
    dx(:,1) = x(:,1).^2 + u(1);
    dx(:,2) = x(:,2) + u(2);
end    

end

function dx = dynamics_cell_helper(obj, x, u, d, dims, dim)

switch dim
  case 1
    dx = x{dims==1}.^2 + u{1};
  case 2
    dx = x{dims==2} + u{2};
  otherwise
    error('Only dimension 1-2 are defined for the dynamics!')
end
end