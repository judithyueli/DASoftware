classdef Saetrom < handle
    properties
        nstep = [];
        step = [];
        m = [];
        n = [];
        H = [];
    end
    methods
        % Constructor
        function obj = Saetrom()
            % Check input
            % Initialize parameters by case1 = Saetrom(param);
            obj.m = 100; %param.m;
            obj.n = 13; %param.n;
            obj.step = 1;% begin from time 1
            obj.nstep = 10;
            % Construct H that is fixed in time
            Hmtx = zeros(13,100);
            Hmtx(1,4:6) = 1;
            Hmtx(2,14:16) = 1;
            Hmtx(3,24:26) = 1;
            Hmtx(4,34:36) = 1;
            Hmtx(5,39:41) = 1;
            Hmtx(6,44:46) = 1;
            Hmtx(7,49:51) = 1;
            Hmtx(8,54:56) = 1;
            Hmtx(9,59:61) = 1;
            Hmtx(10,64:66) = 1;
            Hmtx(11,74:76) = 1;
            Hmtx(12,84:86) = 1;
            Hmtx(13,94:96) = 1;
            obj.H = Hmtx;
        end
        % Observation equation
        function y = h(obj,x)
            Hmtx = obj.H;
            y = Hmtx*x;
        end
        % Forecast equation
        function x = f(obj,x)
            % need to pass obj as a handle
            if (size(x,1) ~= obj.m) || (size(x,2) ~= 1)
                error('x is not the right size');
            else
            F = getF(obj);
            x = F*x;
            obj.step = obj.step + 1; % obj.step is modified after each call of f(x)
            end
        end
        % Get transition matrix F, a function of step k
        function F = getF(obj)
            % F is constructed to move 0<x<55 but 56<x<100 remains static
            F = eye(obj.m, obj.m);
            if (obj.step>=1) && (obj.step<=obj.nstep)
                k = obj.step;
            else
                error('k must be an iteger from 1 to 10');
            end
            Fin = diag([0.5 0.3*ones(1,8) 0.5],0) + ...
                diag([0.3*ones(1,8) 0.5],-1) +...
                diag([0.5 0.3*ones(1,8)],1);
            F(5*(k-1)+1:5*(k+1),5*(k-1)+1:5*(k+1)) = Fin;
        end
    end
end