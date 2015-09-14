function kf = initializeSSM(obj,kf)
% initialize state space model(SSM) of Target tracking model for a given kf
% type (KF/EKF)
% map model properties to filter
kf.m = obj.m;
kf.n = obj.n;

if isprop(kf,'P')
	kf.P = diag([1e2 10 1e2 10 5e-4]');
end

if isprop(kf,'Q')
    dt = obj.dt;
	kf.Q = [
        dt^4/4 dt^3/2 0 0 0;
        dt^3/2 dt^2 0 0 0;
        0 0 dt^4/4 dt^3/2 0;
        0 0 dt^3/2 dt^2 0;
        0 0 0 0 obj.q*dt];
end

if isprop(kf,'R')
	kf.R = diag([obj.sigma_rho obj.sigma_theta]);
end

if isprop(kf,'H')
	kf.H = obj.H;
end

if isprop(kf,'K')
	kf.K = zeros(kf.m,kf.n);
end

if isprop(kf,'variance')
	kf.variance = [1e2 10 1e2 10 5e-4]';% TODO: change to VarOfState
end

% initialize x
if isprop(kf,'x')
    kf.x.t = 0;
    x0 = [1e3, 3e2, 1e3, 0, -obj.rate*pi/180]';
	kf.x.vec = x0 + sqrt(obj.P0)*randn(size(x0));
end

% if isprop(kf,'PHT')
% end

if isprop(kf,'variance_Q')
	kf.variance_Q = var(kf.Q);
end

% if isprop(kf,'QHT')
% 	kf.QHT = zeros(obj.m,obj.n);
% end

% CSKF
if isprop(kf,'A')
    [A,C,~] = svd(kf.P);
	kf.A = A;
    kf.C = C;
end

% if isprop(kf,'C')
% 	kf.C = kf.getCompCov(obj.loc,obj.kernel,kf.A);
% end

if isprop(kf,'V')
	kf.V = kf.A'*kf.Q*kf.A;
end

end

