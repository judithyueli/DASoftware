%% Compile mex code for a new kernel
syms r;                         % seperation between two points
kernel = exp(-sqrt(r^0.5)/30);  % user input kernel expression here, kernel has to be a symbolic function
outputfile = 'inv_quad';
make(r,kernel,outputfile);
