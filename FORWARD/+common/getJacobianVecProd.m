function Fu = getJacobianVecProd(f,x,u,a,fx,flag)
% compute Jacobian matrix vector product Fu using matrix free approach
% Fu = (f(x+au) - f(x))/a
% input:
%   f:  function handle
%       nonlinear or linear function f(x)
%   x:  vector of size m x 1
%       point of evaluation
%   u:  vector of size m x 1
%       perturbation 
%   a:  scalar 
%       a scalig factor a = delta*||x||, cannot be zero
%   fx: vector of n x 1
%       function value at x
%   flag: 1 or 2
%       upwind or central scheme for derivative computation
assert(norm(u)>0);
assert(size(u,1)==size(x,1));
assert(a>0);
b = a/norm(u);
switch flag
    case 1
        Fu = (f(x+b*u)-fx)/b;
    case 2
        Fu = (f(x+b*u)-f(x-b*u))/2/b;
end
end