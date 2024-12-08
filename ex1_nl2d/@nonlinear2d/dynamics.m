function dx = dynamics(obj, ~, x, u, ~)
if ~iscell(u)
  u = num2cell(u);
end

if iscell(x)
  dx = cell(obj.nx, 1);
  for i = 1:length(obj.dims)
        dx{i} = dynamics_cell_helper(obj, x, u, obj.dims, obj.dims(i));
  end
end
end

function dx = dynamics_cell_helper(obj, x, u, dims, dim)

switch dim
  case 1
    dx = x{dims==1}.^2 + u{1};
  case 2
    dx = x{dims==2} + u{2};
  otherwise
    error('Only dimension 1-2 are defined for the dynamics!')
end
end