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
    if any(dims == 3)
        uOpt{3} = (deriv{dims==3}>=0)*obj.uRange{1}(3) + (deriv{dims==3}<0)*obj.uRange{2}(3);
    end
    if any(dims == 6)
        uOpt{6} = (deriv{dims==6}>=0)*obj.uRange{1}(6) + (deriv{dims==6}<0)*obj.uRange{2}(6);
    end
else
  error('Unknown uMode!')
end

end