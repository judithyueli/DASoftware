classdef CSKF <handle
    % Created by Judith Li 3/27
    % Modified by Judith Li 3/30
    properties
        n; % number of measurements
        m; % number of unknowns
        x; % state estimated by CSKF
        nt; % total assimilation step
        K; % Kalman gain
        kernel; % kernel used for initialization
        t_assim = 0; % assimilation step count
        t_forecast = 0;% forecast step count
        %%%%
        N; % number of basis
        A; % orthorgonal basis selected using DCT or rSVD
        C; % compressed covariance of P
        V; % compressed covariance of Q
        R; % meausurement error covariance
        FA; % Jacobian matrix vector for f(x)
        HA; % Jacobian matrix vector for h(x)
        BasisType; % DCT or rSVD
        P; % full covariance (for testing purpose)
        % TODO: extension for augmented state
    end
    methods
        function obj = CSKF(param,fw)
            obj.N = param.N;
            obj.BasisType = param.BasisType;
            obj.kernel = param.kernel;
            % initialize state using fw.getx
            rng(101);
            obj.x = fw.getx(fw.loc,obj.kernel); % TODO: hard coding
            obj.A = getBasis(obj,fw);
            obj.C = getCompCov(obj,fw);
            obj.V = zeros(size(obj.C)); % no Q
            %             obj.V = getCompCov(obj.A,obj.kernel); % TODO: add Q
            obj.R = param.obsstd.*eye(fw.n,fw.n);
            obj.nt = param.nt;
            obj.m = fw.m;
            obj.n = fw.n;
            obj.P = obj.A*obj.C*obj.A'; % for test
        end
        
        function predict(obj,fw)
            % Propagate state x and its covariance P
                obj.x = fw.f(obj.x);    % note that it changes fw
                obj.FA = getFA(obj,fw);
                U = obj.A'* obj.FA;
                obj.C = U*obj.C*U' + obj.V;
            obj.t_forecast = obj.t_forecast + 1;
            obj.P = obj.A*obj.C*obj.A'; % for test
        end
        
        function update(obj,fw,z)
            % update x using measurement z
            obj.HA = getHA(obj,fw);
            HPHT = obj.HA*obj.C*obj.HA';%nN^2 + n^2N
            AA = HPHT + obj.R; % 2nN^2, innovation matrix
            BB = obj.HA*obj.C;
            XX = AA\BB;
            obj.K = obj.A*XX';
            obj.x.vec = obj.x.vec + obj.K*(z-fw.h(obj.x));
            obj.C = (eye(size(obj.C))-XX'*obj.HA)*obj.C;%Nmn+ N^2 + N^3
            obj.t_assim = obj.t_assim + 1;
            obj.P = obj.A*obj.C*obj.A'; % for test
        end
        
        function FA = getFA(obj,fw)
            FA = fw.F*obj.A; % hard coding for Saetrom
        end
        
        function HA = getHA(obj,fw)
            HA = fw.H*obj.A; % hard coding for Saetrom
        end
        
        function A = getBasis(obj,fw)
            P0 = common.getQ(fw.loc,obj.kernel);
            switch obj.BasisType
                case 'DCT'
                    error('to be added');
                case 'rSVD'
                    [A,~,~] = RandomizedCondSVD(P0,obj.N,1); % hard code q = 1 for smooth spectrum
                case 'SVD'
                    [A,~,~] = svd(P0);
                    A = A(:,1:obj.N);
                otherwise
                    error('not a valid basis type');
            end
        end
        
        function C = getCompCov(obj,fw)
            % hard code, use mxBBFMM2D instead
            P0 = common.getQ(fw.loc,obj.kernel);
            C = obj.A'* P0 * obj.A;
        end
        
    end
end
