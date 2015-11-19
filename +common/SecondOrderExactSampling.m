function [E] = SecondOrderExactSampling(U, S)
% modify from Hoteit et al., 2001
% E: size m x r+1, r+1 realziations of size mx1 to give a r-rank approxiamte the covariance P
% using Pe = EE'/(r) is exactly the same as USU'
% N: generate the N realizations from covariace P
% r: only the first r eigenvectors are used to generate samples from P

% step1: generate beta*N eigenvectors U (m x beta*N) and S (beta*N x beta*N) from covariance P
% [U,S,V] = RandomizedCondSVD(P,beta*N,1);
r = size(U,2);
% step2: generate a random matrix Z (r x r) with orthonormal rows
Z = common.get_orthonormal(r,r);
% step3: generate a householder matrix of 
y = 1./sqrt(r+1)*ones(r+1,1);
[v,beta,s] = gallery('house', y);
H = eye(r+1)- beta*v*v';
H = H(:,2:end); 
O = H*Z; % r+1 x r random matrix that has columns orthogonal to v
E = U*sqrt(S)*O';
E = E.*sqrt(r);
% step4: scale to the correct zero mean
% Emean = repmat(mean(E')',1,N);
% E = E-Emean; % the rank of E is up to N-1
% Estd = std(E')';
% E = bsxfun(@rdivide,E,Estd);
% each column of E is a realization from N(0,P)
end