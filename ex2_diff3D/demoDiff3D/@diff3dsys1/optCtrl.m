function uOpt = optCtrl(obj, ~, ~, deriv, uMode)
% uOpt = optCtrl(obj, t, y, deriv, uMode, dims)

%% Input processing
if nargin < 5
  uMode = 'min';
end
if nargin < 6
  dims = obj.dims;
end
if ~iscell(deriv)
  deriv = num2cell(deriv);
end

uOpt = cell(obj.nu, 1);

%% Optimal control
if strcmp(uMode, 'min')
  for i = 1:2
    if any(dims==i)
        uOpt{i} = (deriv{dims==i}>=0)*obj.uRange{i}(1) + (deriv{dims==i}<0)*obj.uRange{i}(2);
    end
  end
else
  error('Unknown uMode!')
end

end