function dOpt = optDstb(obj, t, xs, deriv, dMode, ~)

%% Input processing
if nargin < 5
  dMode = 'max';
end

%% Optimal control
if iscell(deriv)
  dOpt = cell(obj.nd, 1);
  if strcmp(dMode, 'max')
    dOpt = (deriv{1}>=0)*obj.dMax+(deriv{1}<0)* obj.dMin;

  elseif strcmp(dMode, 'min')
    dOpt = (deriv{1}<=0)*obj.dMax+(deriv{1}>0)* obj.dMin;

    error('Unknown dMode!')
  end  
  
else
  uOpt = zeros(obj.nd, 1);
  if strcmp(dMode, 'max')
    dOpt = (deriv(1)>=0)*obj.dMax+(deriv(1)<0)*obj.dMin;
    
  elseif strcmp(dMode, 'min')
    dOpt = (deriv(1)<=0)*obj.dMax+(deriv(1)>0)*obj.dMin;
  else
    error('Unknown dMode!')
  end
end




end