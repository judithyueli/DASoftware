classdef HiKF < DA
%{
    HiKF is a fast Kalman filter variant for a dynamic system with a random-walk forecast model (F=I)  
%}
    % Created on 09/06/2015 by Judith Li
    % Modified on /2015 by Judith Li
    % Reference:
    % 
    properties
        PHT;    % m x n state error cross-covariance
        QHT;    % m x n model error cross-covariance
        R;      % n x n measurement error covariance
        H;      % measurement operator
        F;      % transition matrix
        variance;
        variance_Q;
        theta;  % hyperparameter
        z;      % true observation
        y;      % predicted observation
        dy;     % innovation
    end

    methods
        function obj = HiKF(param,fw)
            % method specific initialization
            % copy properties from param and fw to obj
            obj.kernel = param.kernel;
            obj.nt = param.nt;
            obj.m = fw.m;
            obj.n = fw.n;
            obj.loc = fw.loc;
            obj.theta = param.theta;
            rng(param.seed);

            % Initializing state space models
            obj.x = fw.getx(); %hard code for Frio case
            obj.H = fw.H;
            obj.PHT = obj.theta(1)*obj.theta(2)*zeros(obj.m,obj.n);
            obj.variance = zeros(obj.m,1);
            obj.variance_Q = obj.theta(1)*obj.theta(2)*ones(obj.m,1);
            obj.QHT = obj.theta(1)*obj.theta(2)*common.getKernelMatrixProd(obj.kernel,obj.loc,obj.H');
            obj.R = obj.theta(2)*eye(obj.n,obj.n);
            obj.t_assim = 0;
            obj.t_forecast = 0;
            % check
            % is case1.H, case1.h, case1.F, case1.f existed?
        end

        function update(obj,fw)
            % Update state x and cross-covariance PHT by assimilating data z
            PHT = obj.PHT;
            x = obj.x;
            z = fw.zt;
            H = obj.H;
            variance = obj.variance;
            R = obj.R;

            % innovation
            y = fw.h(x);
            dy = z - y;
            HPHT = H*PHT;
            K = PHT/(HPHT + R);
            x.vec = x.vec + K*dy;
            variance = variance - sum(K.*PHT,2);
            PHT = PHT - K*HPHT;
            
            obj.x = x;
            obj.y = y;
            obj.dy = dy;
            obj.PHT = PHT;
            obj.K = K;
            obj.variance = variance;
            obj.t_assim = obj.t_assim + 1;
        end

        function predict(obj,fw)
            % Propagate state x and its cross-covariance PHT
            PHT = obj.PHT;
            QHT = obj.QHT;
            variance = obj.variance;
            variance_Q = obj.variance_Q;

            obj.x = obj.x;              % random walk model
            obj.PHT = PHT + QHT;        % k+1|k
            obj.variance = variance + variance_Q;

            obj.t_forecast = obj.t_forecast + 1;
        end

        function obj = addRegularization(obj,param)
            if isfield(param,'theta')
                obj.theta = param.theta;
                obj.PHT = obj.theta(1)*obj.theta(2)*obj.PHT;
                obj.QHT = obj.theta(1)*obj.theta(2)*obj.QHT;
                obj.R = obj.theta(2)*obj.R;
                obj.variance = obj.theta(1)*obj.theta(2)*obj.variance;
                obj.variance_Q = obj.theta(1)*obj.theta(2)*obj.variance_Q;
            end
        end

    end
    
end