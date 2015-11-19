classdef EnKF < DA
    properties
        N; % rank, ensemble size is N+1
        E; % each column is ensemble members (transformed)
        R; % measurement error covariance
        Q; % model error covariance
        SampleMethod; % Sampling approach
        x_var;  % state variance
        z_var; % observation variance
        err; % approximation error of covariance matrix
    end
    methods
        function obj = EnKF(param,fw)
            obj.m = fw.m;
            obj.n = fw.n;
            obj.N = param.N;
            %             obj.SampleMethod = param.SampleMethod;
            obj.kernel = param.kernel;
            obj.loc = fw.loc;
            % generate initial ensemble with N(x,P)
            obj.SampleMethod = 2;
            rng(101);
            obj.x = fw.getx(fw.loc,obj.kernel);
            rng(100)
            obj.E = repmat(obj.x.vec,1,obj.N+1) + obj.getSample(obj.SampleMethod,obj.N);
            obj.x_var = obj.getvar(obj.E);
            obj.Q = zeros(obj.m,obj.m);
            obj.z_var = param.obsstd.^2;
            obj.R = obj.z_var*eye(fw.n,fw.n);
            obj.nt = param.nt;
        end
        function predict(obj,fw)
            % propagate each ensemble member and adding noise
            %             W = obj.getSample(obj.SampleMethod,obj.N);
            W = zeros(obj.m,obj.N+1); % hard coded
            x0 = obj.x;
            for i = 1:obj.N+1
                x0.vec = obj.E(:,i);
                x1 = fw.f(x0);
                obj.E(:,i) = x1.vec + W(:,i);
            end
            obj.x.vec = mean(obj.E,2);
            obj.t_forecast = obj.t_forecast + 1;
            obj.x_var = obj.getvar(obj.E);
        end
        
        function update(obj,fw)
            % true observation
            % forecast observation
            D = zeros(obj.n,obj.N+1);
            HE = zeros(obj.n,obj.N+1);
            for j = 1:obj.n
                D(:,j) = fw.zt + sqrt(obj.z_var)*randn(size(fw.zt)); 
                %TODO(ju): obj.z_var is vector instead of scalar
            end
            for j = 1:obj.N+1
                xj = obj.x;
                xj.vec = obj.E(:,j);
                HE(:,j) = fw.h(xj);
            end
            % update ensemble
            [obj.E,obj.K] = common.EnKF(HE,D,obj.E,1,diag(obj.R));
            obj.x.vec = mean(obj.E,2);
            obj.t_assim  = obj.t_assim + 1;
            obj.x_var = obj.getvar(obj.E);
        end
    end
    methods(Access = private)
        function E = getSample(obj,method,nRank)
            switch method
                case 1
                    E = randn(da.m,nRank+1);
                case 2
                    % use soes to generate N+1 sample with mean 0
                    P = common.getQ(obj.loc,obj.kernel);
                    [U,S,~] = common.RandomizedCondSVD(P,nRank,1);
                    obj.err = norm(U*S*U'-P,'fro')/norm(P,'fro');
                    E = common.SecondOrderExactSampling(U, S);
                otherwise
                    Error('method has to be a number betwee 1 and 3');
            end
            
        end
        function x_var = getvar(obj,E)
            ne = size(E,2);
            A = E - E*(1/(ne)*ones(ne,ne));
            x_var = sum(A.*A/(ne-1),2);
        end
    end
end