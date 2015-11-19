function [E, U, S] = generateSamples(kernel_fun, loc, flag, N)
%%% Generate N+1 samples from a kernel matrix P using ordinary sampling or
%%% second order exact sampling
%%% Input:
%%%         N:          scalar
%%%                     rank of the new kernel matrix
%%%         kernel_fun: a function handle
%%%                     e.g., @(h) exp(-(h./900).^0.5)

%%%         loc:        (m,dim) matrix
%%%                     e.g., (x1,y1,z1)
%%%                           (x2,y2,z2)
%%%         flag:       scalar
%%%                     1 (generate N+1 realizations)
%%%                     2 (generate N+1 realizations using
%%%                     second-order-exact-sampling)
%%%Output:
%%%         E:          (m,N+1) matrix
%%%                     N+1 realizations
%%%         U:          (m,N) matrix
%%%                     first N eigenvectors of P
%%%         S:          (N,N) matrix
%%%                     first N eigenvalues

end