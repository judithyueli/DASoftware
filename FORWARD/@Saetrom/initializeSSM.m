function kf = initializeSSM(obj,kf)
% initialize state space model(SSM) of Saetrom for given kf
% type (KF,HiKF,CSKF)

% map model properties to filter
kf.m = obj.m;
kf.n = obj.n;

if isprop(kf,'P')
	kf.P = common.getQ(obj.loc,obj.kernel);
end

if isprop(kf,'Q')
	kf.Q = zeros(kf.m,kf.m);
end

if isprop(kf,'R')
	kf.R = obj.obsvar*eye(kf.n,kf.n);
end

if isprop(kf,'H')
	kf.H = obj.H;
end

if isprop(kf,'K')
	kf.K = zeros(kf.m,kf.n);
end

if isprop(kf,'variance')
	kf.variance = obj.xt_var*ones(kf.m,1);% TODO: change to VarOfState
end

if isprop(kf,'x')
    rng(obj.seed);
	kf.x = obj.getx();
end

if isprop(kf,'PHT')
	kf.PHT = common.getKernelMatrixProd(obj.kernel,obj.loc,obj.H');
end

if isprop(kf,'variance_Q')
	kf.variance_Q = zeros(obj.m,1);
end

if isprop(kf,'QHT')
	kf.QHT = zeros(obj.m,obj.n);
end

% CSKF
if isprop(kf,'A')
	kf.A = kf.getBasis(obj.loc,obj.kernel);
end

if isprop(kf,'C')
	kf.C = kf.getCompCov(obj.loc,obj.kernel,kf.A);
end

if isprop(kf,'V')
	kf.V = zeros(size(kf.C));
end
% EKF
end