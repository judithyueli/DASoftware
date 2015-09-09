function PH = getKernelMatrixProd(kernelfun,loc,H)
% Compute a matrix vector product PH = P*H, where P of size m x m
% is defined by a kernel function and H is a matrix of size m x n
% the algorithm is O(mn)
P = common.getQ(loc,kernelfun);
PH = P*H;
end

