classdef TargetTracking < handle
    % model air-traoffic moniotirng scenario, where an aircraft executes a
    % maneuvering turn in a horizontal plane at an unknown turn rate Sigma
    % at tim
    properties
        m = 5;          % number of unknown
        n = 2;          % number of observation
        dt_true = 1;    % true dt used in simulation
        dt;             % dt used in filter prediction
        q  = 0;         %parameter specifies how the turning rate changes (or 1.75e-4)
        nt;             % total simulation steps
        rate;
        sigma_rho = 100;
        sigma_theta = 1e-5;
        x0;
        P0 = diag([1e2 10 1e2 10 5e-4]'); % last entry control the inital error in turning rate
        Q;
        R;
        xt;
        zt;
        F;
        Ffun;
        Hfun;
        H;
    end
    methods
        function obj = TargetTracking(param)
%             obj.Q = [
%                 dt^3/3 dt^2/2 0 0 0;
%                 dt^2/2 dt 0 0 0;
%                 0 0 dt^3/3 dt^2/2 0;
%                 0 0 dt^2/2 dt 0;
%                 0 0 0 0 obj.q*dt];
            % user specified parameters
            obj.rate = param.rate;
            obj.dt = param.dt;
            dt = obj.dt_true;
            obj.nt = param.nt;
            seed = param.seed;
            theta = param.theta;
            obj.Q = 0.01*[
                dt^4/4 dt^3/2 0 0 0;
                dt^3/2 dt^2 0 0 0;
                0 0 dt^4/4 dt^3/2 0;
                0 0 dt^3/2 dt^2 0;
                0 0 0 0 obj.q*dt];
            obj.x0 = [1e3, 3e2, 1e3, 0, -obj.rate*pi/180]';
            obj.xt.vec = obj.x0;
            rng(seed);
            obj.R = diag([obj.sigma_rho obj.sigma_theta]);
        end
        
        function [xoutput,z] = simulate(obj,xinput)
        % Simulate the movement of target
        dt = obj.dt_true;
        x = xinput.vec;
        % x = f(x) + u*randn
        x = [1 sin(x(5)*dt)/x(5) 0 (cos(x(5)*dt)-1)/x(5) 0;
            0  cos(x(5)*dt) 0 -sin(x(5)*dt) 0;
            0 (1-cos(x(5)*dt))/x(5) 1 sin(x(5)*dt)/x(5) 0;
            0 sin(x(5)*dt) 0 cos(x(5)*dt) 0;
            0 0 0 0 1]*x;
        [A,C,~] = svd(obj.Q);
        x = x + A*sqrt(C)*randn(size(x));
        xoutput.vec = x;
        % y = h(x) + v
        rho = sqrt(x(1)^2 + x(3)^2);
        theta = atan(x(3)/x(1));
        y = [rho, theta]';
        z.vec = y + sqrt(obj.R)*randn(length(obj.R),1);
        end
        
        function output = f(obj,input)
            dt = obj.dt;
            x = input.vec;
            x = [1 sin(x(5)*dt)/x(5) 0 (cos(x(5)*dt)-1)/x(5) 0;
                0  cos(x(5)*dt) 0 -sin(x(5)*dt) 0;
                0 (1-cos(x(5)*dt))/x(5) 1 sin(x(5)*dt)/x(5) 0;
                0 sin(x(5)*dt) 0 cos(x(5)*dt) 0;
                0 0 0 0 1]*x;
            output.vec = x;
        end
        
        function output = h(obj,input)
            x = input.vec;
            rho = sqrt(x(1)^2 + x(3)^2);
            theta = atan(x(3)/x(1));
            y = [rho, theta]';
            output.vec = y + sqrt(obj.R)*randn(length(obj.R),1);
        end
        
        function H = getH(obj,input)
            x = input.vec;
            Hfun = @(x) [
                x(1)/(sqrt(x(1)^2+x(3)^2)) 0 x(3)/sqrt(x(1)^2 + x(3)^2) 0 0;
                -x(3)/(x(1)^2+x(3)^2) 0 x(1)/(x(1)^2 + x(3)^2) 0 0];
            H = Hfun(x);
        end
        
        function F = getF(obj,input)
            x = input.vec;
            dt = obj.dt;
            dx1 = @(x) x(2)*(dt*x(5)*cos(dt*x(5))-sin(dt*x(5)))/x(5)^2 - x(4)*(dt*x(5)*sin(x(5)*dt)+cos(dt*x(5))-1)/x(5)^2;
            dx2 = @(x) -dt*sin(dt*x(5))*x(2) - dt*cos(dt*x(5))*x(4);
            dx3 = @(x) x(2)*(dt*x(5)*sin(x(5)*dt)+cos(dt*x(5))-1)/x(5)^2 + x(4)*(dt*x(5)*cos(dt*x(5))-sin(dt*x(5)))/x(5)^2;
            dx4 = @(x) dt*cos(dt*x(5))*x(2) - dt*sin(dt*x(5))*x(4);
            Ffun = @(x) [
                1 sin(x(5))/x(5) 0 (cos(x(5)*dt)-1)/x(5) dx1(x);
                0  cos(x(5)*dt) 0 -sin(x(5)*dt) dx2(x);
                0 (1-cos(x(5)*dt))/x(5) 1 sin(x(5)*dt)/x(5) dx3(x);
                0 sin(x(5)*dt) 0 cos(x(5)*dt) dx4(x);
                0 0 0 0 1];
            F = Ffun(x);
        end
        
        function visualize(obj,fwArray,daArray)
            Xe = zeros(obj.nt,1);
            Ye = zeros(obj.nt,1);
            for i = 1:obj.nt
                xt = fwArray{i}.xt.vec;
                Xe(i) = xt(1);
                Ye(i) = xt(3);
                xest1 = daArray{i}.x.vec; 
                Xs(i) = xest1(1); 
                Ys(i) = xest1(3);
            end
            figure;
            subplot(1,2,1)
            comet(Xe,Ye)
            subplot(1,2,2)
            comet(Xs,Ys)
        end
    end
    methods
        % initialize state space model
        da = initializeSSM(obj,da);
    end
end