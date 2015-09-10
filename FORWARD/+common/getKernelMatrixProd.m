function PH = getKernelMatrixProd(kernelfun,loc,H)
% Compute a matrix vector product PH = P*H, where P of size m x m
% is defined by a kernel function and H is a matrix of size m x n
% the algorithm is O(mn)
% input:
% kernelfun: function handle
    %example: @(h)exp(-sqrt(h.^0.5)./30)
% compare with the full matrix
% P = common.getQ(loc,kernelfun);
% PH = P*H;
nCheb = 6;
assert(size(loc,2)==2); % only for 2D
PH = expfun(loc(:,1),loc(:,2),H,nCheb);
end

