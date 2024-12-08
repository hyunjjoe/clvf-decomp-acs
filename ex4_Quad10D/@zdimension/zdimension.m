classdef zdimension < DynSys
  properties
    uMin
    uMax
    dMin
    dMax
    kT
    g
  end
  
  methods
      function obj = zdimension(x, params)
      
      if numel(x) ~= 2
        error('Initial state does not have right dimension!');
      end
      
      if ~iscolumn(x)
        x = x';
      end
      
      obj.x = x;
      obj.xhist = obj.x;
      
      obj.uMin = params.u_min;
      obj.uMax = params.u_max;
      obj.dMin = params.d_min;
      obj.dMax = params.d_max;

      obj.pdim = 1;
      obj.nx = 2;
      obj.nu = 1;
      obj.nd = 1;
      
      obj.kT = params.kT;   
      obj.g = params.g; 
    end
    
  end % end methods
end % end classdef
