function test()
% loc = [0 0 ; 1 1];
% kernel = @(h) exp(-h);
% PH = common.getKernelMatrixProd(kernel,loc,[1 1]');
% fprintf(' PH(1) is %d should equal to %d\n', PH(1),1.2431)
% fprintf(' PH(2) is %d should equal to %d\n', PH(2),1.2431)

% test getJacobianVecProd
f = @(x) sin(x);
x = [1;2];
u = [1;1];
F = [cos(x(1)) 0; 0 cos(x(2))];
Fu_true = F*u;
fu1 = @(delta) common.getJacobianVecProd(f,x,u,delta*norm(x),f(x),1);
fu2 = @(delta) common.getJacobianVecProd(f,x,u,delta*norm(x),f(x),2);
delta = logspace(-10,-5,100);
for i = 1:length(delta)
y1 = fu1(delta(i));
y2 = fu2(delta(i));
z1(i) = y1(1);
z2(i) = y2(1);
end
figure;
loglog(delta,z1,'-',delta,z2,'r-',delta(1),Fu_true(1),'*')
figure;
loglog(delta,abs(z1-z2),'r-')
end