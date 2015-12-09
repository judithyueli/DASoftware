function kf = initializeSSM(obj,kf,param)
% initialize state space model(SSM) of ScalarSSM example for a given object kf
% of type (KF,HiKF,CSKF)

% map model properties to filter
kf.m = obj.m;
kf.n = obj.n;

if isprop(kf,'P')
    % input covariance matrix P
	kf.P = param.P;
end

if isprop(kf,'Q')
    % input model error covariance matrix Q
	kf.Q = param.Q;
end

if isprop(kf,'R')
    % observation error covariance matrix
	kf.R = param.R;
end

if isprop(kf,'H')
    % measurement operator H
	kf.H = param.H;
end

if isprop(kf,'F')
    % measurement operator H
	kf.F =param.F;
end

if isprop(kf,'K')
    % Kalman gain
	kf.K = zeros(kf.m,kf.n);
end

if isprop(kf,'variance')
	kf.variance = diag(kf.P);% TODO: change to VarOfState
end

if isprop(kf,'x')
    % initial guess, use x.vec instead of x
	kf.x.vec = param.x;
end

% HiKF
if isprop(kf,'PHT')
	kf.PHT = kf.P*kf.H';
end

if isprop(kf,'variance_Q')
	kf.variance_Q = diag(kf.Q);
end

if isprop(kf,'QHT')
	kf.QHT = kf.Q*kf.H';
end

% CSKF
if isprop(kf,'A')
	kf.A = 1;
end

if isprop(kf,'C')
    % compressed state error covariance
	kf.C = kf.P;
end

if isprop(kf,'V')
    % compressed model error covaraince
	kf.V = kf.Q;
end
% EKF
end

