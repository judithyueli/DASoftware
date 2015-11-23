classdef ScalarSSM < handle
    properties
        xt;
        zt;
        m;
        n;
        H;
        F;
        Q;
        R;
        P;
        x;  % initial mean
        obsvar;    % true variance of observation
        forvar;  % true variance of forecast
    end
    
    methods
        function obj = ScalarSSM(param)
            obj.m = param.m;
            obj.n = param.n;
            obj.H = param.H;
            obj.F = param.F;
            obj.zt.vec = 2.3846;
            obj.xt.vec = 1;
            obj.R = param.R;
            obj.Q = param.Q;
            obj.x = param.x;
            obj.P = param.P;
            obj.xt = obj.getx(100);
            obj.obsvar = diag(obj.R);
            obj.forvar = diag(obj.Q);
        end
        function y = h(obj,x)
            y.vec = obj.H*x.vec;
        end
        function x = f(obj,x)
            x.vec = obj.F*x.vec;
        end
        function [xnew,z] = simulate(obj,x)
            % propagating x to xnew and z, note they are structures
            xnew = obj.f(x);
            xnew.vec = xnew.vec + sqrt(obj.forvar)*randn;
            ynew = obj.h(xnew);
            z.noisefree = ynew.vec;
            z.vec = z.noisefree + sqrt(obj.obsvar)*randn;
        end
        function x = getx(obj,seed)
            % initialize x from N(0.5,0.5)
            rng(seed)
            x.vec = obj.x + sqrt(obj.P)*randn;
        end
        function F = getF(obj,x)
            F = obj.F;
        end
        function H = getH(obj,x)
            H = obj.H;
        end
    end
end