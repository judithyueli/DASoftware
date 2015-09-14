classdef LinearSSM < handle
    properties
        xt;
        zt;
        m;
        n;
        H;
        F;
        Q;
        R;
    end
    
    methods
        function obj = LinearSSM(param)
            obj.m = 1;
            obj.n = 1;
            obj.H = 5;
            obj.F = 1.2;
            obj.Q = 0.1;
            obj.R = 2;
            obj.zt.vec = 2.3846;
            obj.xt.vec = 1;
        end
        function y = h(obj,x)
            y.vec = obj.H*x.vec;
        end
        function x = f(obj,x)
            x.vec = obj.F*x.vec;
        end
        function F = getF(obj,x)
            F = obj.F;
        end
        function H = getH(obj,x)
            H = obj.H;
        end
    end
end