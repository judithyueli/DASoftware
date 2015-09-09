function test()
loc = [0 0 ; 1 1];
kernel = @(h) exp(-h);
PH = common.getKernelMatrixProd(kernel,loc,[1 1]');
fprintf(' PH(1) is %d should equal to %d\n', PH(1),1.2431)
fprintf(' PH(2) is %d should equal to %d\n', PH(2),1.2431)    
end