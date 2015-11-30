classdef KF < DA
    % Created on 18/03/2015 by Judith Li
    % Modified on 24/03/2015 by Judith Li
    properties
        P;          % state error covariance
        Q;          % model error covariance
        R;          % measurement error covariance
        H;          % measurement operator
        F;          % transition matrix
        variance;
        theta;      % hyperparameter controlling data fitting
        smoothing;  % option to process data one step ahead
        noQ;        % option for sKF
    end
    methods
        function obj = KF(param,fw)
            % method specific initialization
            % cases1 is an instance of the MODEL class (Saetrom, etc..)
%             obj.kernel = param.kernel;
            rng(101);
            obj.x.vec = 0.5;
            obj.P = 0.5;
            obj.variance = diag(obj.P);
            obj.Q = 0.1;
            obj.R = 2;
            obj.nt = param.nt;
            obj.m = fw.m;
            obj.n = fw.n;
            obj.t_assim = 0;
            obj.t_forecast = 0;
            obj.H = 5;
            obj.F = 1.2;
            if isfield(param,'noQ')
                obj.noQ = param.noQ;
            end
                % check
            % is case1.H, case1.h, case1.F, case1.f existed?
        end
        function update(obj,fw)
            % Update state x and covariance P by assimilating data z
            % form cross covariance
            P = obj.P;
            R = obj.R;
            x = obj.x;
            z = fw.zt;
            H = fw.getH(obj.x);
            y = fw.h(x);
            % Calculate Kalman Gain
            PHT = P*H';
            K = PHT/(H*PHT+R);
            % Update posterior covariance using Ricatti equation
            P = P - K*PHT';
            obj.x.vec = obj.x.vec + K*(z.vec-y.vec);
            obj.P = P;
            obj.variance = diag(P);
            obj.K = K;
            obj.t_assim = obj.t_assim + 1;
            %fw.xt = obj.x;
        end
        function predict(obj,fw)
            % Propagate state x and its covariance P
            x = obj.x;
            P = obj.P;
            Q = obj.Q;
            
            F = fw.getF(x);
            x = fw.f(x);
            P = F*P*F' + Q;
            
            obj.x = x; % note that it changes fw.F and fw.x
            obj.P = P;
            obj.variance = diag(obj.P);
            obj.t_forecast = obj.t_forecast + 1;
        end
        
        % Methods for sKF
        function smooth(obj,fw)
            x = obj.x;
            R = obj.R;
            Q = obj.Q;
            z = fw.zt;
            P = obj.P;
            % get Jacobians
            F   =     fw.getF(x);
            xf  =     fw.f(x);
            y   =     fw.h(xf);
            H   =     fw.getH(xf);
            H1 = H*F;
            if obj.noQ == true
                R1 = R;
            else
                R1 = R+ H*Q*H';
            end
                % smoothing Gain
            dy = z.vec - y.vec;
            L = R1 + H1*P*H1';
            K = P*H1'/L;
            x.vec = x.vec + K*dy;
            P = P - K*H1*P;
            
            obj.P = P;
            obj.x = x;
            obj.K = K;
        end
        
        % Methods for sKF
        function forecast(obj,fw)
            x = obj.x;
            Q = obj.Q;
            P = obj.P;
            R = obj.R;
            z = fw.zt;
            
            if obj.noQ == true
                F = fw.getF(x);
                x = fw.f(x);
                P = F*P*F';
            else
                F = fw.getF(x);
                x = fw.f(x);
                H = fw.getH(x);
                R1 = R + H*Q*H';
                y = fw.h(x);
                %%%%%% scaling K %%%%%%
                K1 = Q*H'/R1;
                %     K1 = Q*H'*Rs'/(Rs*R1*Rs')*Rs;
                %%%%%%%%%%%%%%%%%%%%%%%

                F1 = (eye(size(F))-K1*H)*F;
                Q1 = Q - K1*R1*K1';
            %     x = F1*x + K1*y;
                x.vec = x.vec + K1*(z.vec-y.vec);
                P = F1*P*F1' + Q1;
                obj.K = K1;
            end            
            obj.P = P;
            obj.x = x;
        end
        
        function obj = addRegularization(obj,param)
            if isfield(param,'theta')
                obj.theta = param.theta;
                obj.P = obj.theta(1)*obj.theta(2)*obj.P;
                obj.Q = obj.theta(1)*obj.theta(2)*obj.Q;
                obj.R = obj.theta(2)*obj.R;
                obj.variance = diag(obj.P);
            end
        end
    end
    
end