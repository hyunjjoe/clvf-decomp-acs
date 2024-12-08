function uOpt = optCtrl(obj, t, xs, deriv, uMode, ~)
% uOpt = optCtrl(obj, t, deriv, uMode, dMode, MIEdims)


%% Input processing
if nargin < 5
  uMode = 'min';
end

%% Optimal control
if iscell(deriv)
  uOpt = cell(obj.nu, 1);
  if strcmp(uMode, 'max')
    uOpt = (deriv{2}>=0)*obj.uMax + (deriv{2}<0)* obj.uMin;
    
  elseif strcmp(uMode, 'min')
    uOpt = (deriv{2}>=0)* obj.uMin + (deriv{2}<0)*obj.uMax;
  else
    error('Unknown uMode!')
  end  
  
else
  uOpt = zeros(obj.nu, 1);
  multiplier = deriv(1).*g1 + deriv(2).*g2;
  if strcmp(uMode, 'max')
    uOpt = (deriv{2}>=0)*obj.uMax + (deriv{2}<0)* obj.uMin;
    
  elseif strcmp(uMode, 'min')
    uOpt = (deriv{2}>=0)* obj.uMin + (deriv{2}<0)*obj.uMax;
    
  else
    error('Unknown uMode!')
  end
end




end