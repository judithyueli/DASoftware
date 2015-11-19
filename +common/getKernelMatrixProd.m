function PH = getKernelMatrixProd(kernelfun,loc,H,param)
% Compute a matrix vector product PH = P*H, where P of size m x m
% is defined by a kernel function and H is a matrix of size m x n
% the algorithm is O(mn)
% input:
% kernelfun: function handle
    %example: @(h)exp(-sqrt(h.^0.5)./30)
% compare with the full matrix
if param.mexBBFMM == 0
    P = common.getQ(loc,kernelfun);
    PH = P*H;
else
    nCheb = 6;
    print = false;
    assert(size(loc,2)==2); % only for 2D
    expfun = str2func(param.mexfile_name);
    PH = expfun(loc(:,1),loc(:,2),H,nCheb,print);
end

