function dx = dynamics(obj, ~, x, u, d)
% Dynamics of the sys1 decomposed from the Dubins Car
%    \dot{x}_1 = v * sin(x_2) + d1
%    \dot{x}_2 = w + d2
%   Control: u = w;
digits(8);

if nargin < 5
    d = [0; 0];
end

if iscell(x)
    dx = cell(length(obj.dims), 1);

    for i = 1:length(obj.dims)
        dx{i} = dynamics_cell_helper(obj, x, u, d, obj.dims, obj.dims(i));
    end
else
    if size(x)==2
    dx = zeros(obj.nx, 1);
    
    dx(1) = obj.speed * sin(x(2));
    dx(2) = u;
    end
%     x = reshape(x, [41*41, 2]);
    dx = zeros(size(x));
  
    dx(:,1) = obj.speed .* sin(x(:,2));
    dx(:,2) = u;
end    
end

function dx = dynamics_cell_helper(obj, x, u, d, dims, dim)

switch dim
  case 1
    dx = obj.speed * sin(x{dims==2}) + d{1};
  case 2
    dx = u + d{2};
  otherwise
    error('Only dimension 1-2 are defined for the dynamics of DubinsCars subsystem2!')
end
end
