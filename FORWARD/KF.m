classdef KF < handle
    % Created on 18/03/2015 by Judith Li
    % Modified on 24/03/2015 by Judith Li
    properties
        n; % number of measurements
        m; % number of unknowns
        x; % state estimated by KF
        P; % state error covariance
        Q; % model error covariance
        R; % measurement error covariance
        H; % measurement operator
        F; % transition matrix
        K; % Kalman gain
        nt; % total assimilation step
        kernel; % kernel used for initialization
        t_assim = 0; % assimilation step count
        t_forecast = 0;% forecast step count
    end
    methods
        function obj = KF(param,fw)
            % method specific initialization
            % cases1 is an instance of the MODEL class (Saetrom, etc..)
            obj.kernel = param.kernel;
            obj.x = fw.getx(fw.loc,obj.kernel); % TODO: hard coding
            obj.P = fw.getQ(fw.loc,obj.kernel);
            obj.Q = zeros(fw.m,fw.m);
            obj.R = param.obsstd.*eye(fw.n,fw.n);
            obj.nt = param.nt;
            obj.m = fw.m;
            obj.n = fw.n;
            % check
            % is case1.H, case1.h, case1.F, case1.f existed?
        end
        function update(obj,fw,z)
            % Update state x and covariance P by assimilating data z
            % form cross covariance
            obj.H = fw.H;
            PHT = obj.P*fw.H';
            % Calculate Kalman Gain
            K = PHT/(fw.H*PHT+obj.R);
            % Update posterior covariance using Ricatti equation
            obj.P = obj.P - K*PHT';
            obj.K = K;
            obj.x = obj.x + K*(z-fw.h(obj.x));
            obj.t_assim = obj.t_assim + 1;
            %fw.xt = obj.x;
        end
        function predict(obj,fw)
            % Propagate state x and its covariance P
            if obj.t_forecast == fw.step
               % fw.xt = obj.x;
                obj.x = fw.f(obj.x); % note that it changes fw
                obj.P = fw.F*obj.P*fw.F';
            else
                error('forward model clock is not syned with data assimilation clock');
            end
            obj.t_forecast = obj.t_forecast + 1;
        end
    end
    
%     methods(Access = private,Static)
%         function Q0 = getQ(loc,kernelfun)
%             % Each column of loc saves the coordinates of each point
%             % For 2D cases, loc = [x y]
%             % For 3D cases, loc = [x y z]
%             % np: number of points
%             % nd: number of dimension
%             [np,nd] = size(loc);
%             h = zeros(np,np); % seperation between two points
%             for i = 1:nd
%                 xi = loc(:,i);
%                 [xj,xl]=meshgrid(xi(:),xi(:));
%                 h = h + ((xj-xl)).^2;
%             end
%             h = sqrt(h);
%             Q0 = kernelfun(h);
%         end
%     end
    
    % TODO: define a destructor
end