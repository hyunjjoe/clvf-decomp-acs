function uOpt = optCtrl(obj, ~, ~, deriv, uMode)
% uOpt = optCtrl(obj, t, y, deriv, uMode, dims)

%% Input processing
if nargin < 5
  uMode = 'min';
end

if ~iscell(deriv)
  deriv = num2cell(deriv);
end

%% Optimal control
if strcmp(uMode, 'min')
  uOpt = (deriv{3}>=0)*obj.uRange(1) + (deriv{3}<0)*obj.uRange(2);
else
  error('Unknown uMode!')
end

end