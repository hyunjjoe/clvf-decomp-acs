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

%% Optimal control
if strcmp(uMode, 'min')
    uOpt = (deriv{dims==4}>=0)*obj.uRange(1) + (deriv{dims==4}<0)*obj.uRange(2);
else
  error('Unknown uMode!')
end

end