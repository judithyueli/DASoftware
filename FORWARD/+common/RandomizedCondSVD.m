function [U,S,V] = RandomizedCondSVD(A,N,q)
%
%Low-rank svd via randomized algorithm
%A is matrix to find U, S, and V
%N = rank of reduced rank svd 
%q is 1, or 2 (try 1)
%
%pkk, Aug 29 2013

[m,n] = size(A);
if N>m | N>n
    warning('N set to minimum of n and m')
    N = min(n,m);
end

Omega = randn(n,N+10);
Y = (A*A')^q*A*Omega; % A(A(AO))) 3x(mlogm N)
[Q,S,V] =svd(Y,0); clear S V  % O(mN^2) Y is a tall matrix

B = Q'*A;   

[V,S,Ut] = svd(B',0);
U = Q*Ut;
U = U(:,1:N); S = S(1:N,1:N); V = V(:,1:N);
%TestError = norm(U*S*V'-A)/norm(A)
%commandwindow
%keyboard
end

