classdef doubleIntSub < DynSys
    properties
        % control bounds
        uRange

        % Dimensions that are active
        dims

    end

    methods
        function obj = doubleIntSub(x, uRange, dims)
            % obj = linear3d(x, uRange, dMax, dims)
            %     2d class
            %
            % Dynamics:
            %    \dot{x}_1 = x3
            %    \dot{x}_2 = x3
            %    \dot{x}_3 = u
            %              uMin <= u <= uMax
            % Inputs:
            %   x      - state: [xpos]
            %   uRange - control input
            %
            % Output:
            %   obj       - a 3D sys object  

            if numel(x) ~= obj.nx
              error('Initial state does not have right dimension!');
            end
            
            if ~iscolumn(x)
              x = x';
            end
            
            if nargin < 2
              uRange = [-1,1];
            end
           
            if nargin < 3
              dims = 1:2;
            end

            % Basic system properties
            obj.nx = 2;
            obj.nu = 1;

            obj.x = x;
            obj.xhist = obj.x;
            
            obj.uRange = uRange;
            obj.dims = dims;
        end

    end % end methods
end % end classdef
