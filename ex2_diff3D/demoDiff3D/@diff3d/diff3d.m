classdef diff3d < DynSys
    properties
        % control bounds
        uRange

        % Dimensions that are active
        dims

    end

    methods
        function obj = diff3d(x, uRange, dims)
            % obj = linear3d(x, uRange, dMax, dims)
            %     2d class
            %
            % Dynamics:
            %    \dot{x}_1 = x3 + u1
            %    \dot{x}_2 = x3 + u1
            %    \dot{x}_3 = u2
            %              uMin <= [u1; u2] <= uMax
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
              uRange = {[-1,1],[-1,1],[-0.5,0.5]};
            end
           
            if nargin < 3
              dims = 1:3;
            end

            % Basic system properties
            obj.nx = 3;
            obj.nu = 3;

            obj.x = x;
            obj.xhist = obj.x;
            
            obj.uRange = uRange;
            obj.dims = dims;
        end

    end % end methods
end % end classdef
