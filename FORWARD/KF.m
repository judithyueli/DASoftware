classdef KF < DA
    % Created on 18/03/2015 by Judith Li
    % Modified on 24/03/2015 by Judith Li
    properties
        P; % state error covariance
        Q; % model error covariance
        R; % measurement error covariance
        H; % measurement operator
        F; % transition matrix
        variance; 
    end
    methods
        function obj = KF(param,fw)
            % method specific initialization
            % cases1 is an instance of the MODEL class (Saetrom, etc..)
            obj.kernel = param.kernel;
            rng(101);
            obj.x = fw.getx(fw.loc,obj.kernel); % TODO: hard coding
            obj.P = common.getQ(fw.loc,obj.kernel);
            obj.variance = diag(obj.P);
            obj.Q = zeros(fw.m,fw.m);
            obj.R = param.obsstd.*eye(fw.n,fw.n);
            obj.nt = param.nt;
            obj.m = fw.m;
            obj.n = fw.n;
            obj.t_assim = 0;
            obj.t_forecast = 0;
            obj.H = fw.H;
            % check
            % is case1.H, case1.h, case1.F, case1.f existed?
        end
        function update(obj,fw)
            % Update state x and covariance P by assimilating data z
            % form cross covariance
            P = obj.P;
            H = obj.H;
            R = obj.R;
            PHT = P*H';
            x = obj.x;
            z = fw.zt;
            h = @fw.h;
            % Calculate Kalman Gain
            K = PHT/(H*PHT+R);
            % Update posterior covariance using Ricatti equation
            P = P - K*PHT';
            obj.x.vec = obj.x.vec + K*(z-h(x));
            obj.P = P;
            obj.variance = diag(P);
            obj.K = K;
            obj.t_assim = obj.t_assim + 1;
            %fw.xt = obj.x;
        end
        function predict(obj,fw)
            % Propagate state x and its covariance P
            obj.x = fw.f(obj.x); % note that it changes fw
            obj.P = fw.F*obj.P*fw.F';
            obj.variance = diag(obj.P);
            obj.t_forecast = obj.t_forecast + 1;
        end
    end
    
end