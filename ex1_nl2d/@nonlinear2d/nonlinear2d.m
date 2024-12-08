classdef nonlinear2d < DynSys
    properties
        % control bounds
        uRange
    
        % Dimensions that are active
        dims

    end

    methods
        function obj = nonlinear2d(x, uRange, dims)
            % obj = nonlinear2d(x, uRange, dMax, dims)
            %     2d class
            %
            % Dynamics:
            %    \dot{x}_1 = x^2 + u_1
            %    \dot{x}_2 = y + u_2
            %              uMin <= [u1; u2] <= uMax
            %              dMin <= [d1; d2] <= dMa
            % Inputs:
            %   x      - state: [xpos]
            %   uRange - control input
            %
            % Output:
            %   obj       - a 2D subsystem1 object  

            if numel(x) ~= obj.nx
              error('Initial state does not have right dimension!');
            end
            
            if ~iscolumn(x)
              x = x';
            end
            
            if nargin < 2
              uRange = {[-4,-1];[4,1]};
            end
            
            if nargin < 3
              dims = 1:2;
            end
            
            if ~iscell(uRange)
              uRange = {-uRange; uRange};
            end

            % Basic system properties
            obj.nx = length(dims);
            obj.nu = 2;

            obj.x = x;
            obj.xhist = obj.x;
            
            obj.uRange = uRange;
            obj.dims = dims;
        end

    end % end methods
end % end classdef
