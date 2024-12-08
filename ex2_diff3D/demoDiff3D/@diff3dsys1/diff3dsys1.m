classdef diff3dsys1 < DynSys
    properties
        % control bounds
        uRange

        % Dimensions that are active
        dims

    end

    methods
        function obj = diff3dsys1(x, uRange, dims)
            % obj = linear3d(x, uRange, dMax, dims)
            %     2d class
            %
            % Dynamics:
            %    \dot{x}_1 = x2 + u1
            %    \dot{x}_2 = u2
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
              uRange = {[-1,1],[-0.5,0.5]};
            end
           
            if nargin < 3
              dims = 1:2;
            end

            % Basic system properties
            obj.nx = 2;
            obj.nu = 2;

            obj.x = x;
            obj.xhist = obj.x;
            
            obj.uRange = uRange;
            obj.dims = dims;
        end

    end % end methods
end % end classdef
