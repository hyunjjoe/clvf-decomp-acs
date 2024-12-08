classdef sys2d2 < DynSys
    properties
        % control bounds
        uRange

        % Disturbance
        dRange
    
        % Dimensions that are active
        dims

    end

    methods
        function obj = sys2d2(x, uRange, dRange, dims)
            % obj = sys2(x, uRange, dMax, dims)
            %     2d class
            %
            % Dynamics:
            %    \dot{x}_1 = x^2 + u_x
            %    \dot{x}_2 = y + u_y
            %         u \in [-uMin, uMax]
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
              uRange = [-1 1];
            end
            
            if nargin < 3
              dRange = {0;0};
            end
            
            if nargin < 4
              dims = 1;
            end
            
            if numel(uRange) < 2
              uRange = [-uRange; uRange];
            end
            
            if ~iscell(dRange)
              dRange = {-dRange,dRange};
            end

            % Basic vehicle properties
            obj.pdim = [find(dims == 1)];  % Position dimension
            obj.nx = length(dims);
            obj.nu = 1;
            obj.nd = 1;
            
            obj.x = x;
            obj.xhist = obj.x;
            
            obj.uRange = uRange;
            obj.dRange = dRange;
            obj.dims = dims;
        end

    end % end methods
end % end classdef
