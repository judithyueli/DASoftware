mexBBFMM2D
==========

This is the Matlab MEX gateway files to the package [BBFMM2D](https://github.com/sivaramambikasaran/BBFMM2D).
BBFMM2D provides a __O(N)__ solution to compute matrix-matrix product Q*H, where Q(x,y) is a kernel matrix of size N x N, and N is the number of unknown values at points (x,y) in a 2D domain. 
H is a N x m matrix with N >> m. 

#### Example of kernel type:
+ Gaussian kernel 

      ![guasskernel](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20Q%28r%29%20%3D%20%5Csigma%5E2%20%5Cexp%28-%5Cdfrac%7Br%5E2%7D%7BL%5E2%7D%29)

+ Exponential kernel

      ![expkernel](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20Q%28r%29%20%3D%20%5Cexp%28-%5Cdfrac%7Br%7D%7BL%7D%29)

+ Logrithm kernel

      ![logkernel](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20Q%28r%29%20%3D%20A%20%5Clog%28r%29%2C%20A%3E0)

+ Linear kernel

      ![linearkernel](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20Q%28r%29%20%3D%20%5Ctheta%20r%2C%20%5Ctheta%20%3E0)

+ Power kernel

      ![powerkernel](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20Q%28r%29%20%3D%20%5Ctheta%20r%5Es%2C%20%5Ctheta%20%3E0%2C%200%20%3Cs%20%3C2)
        

###STEP 1: Setup MEX

This package relies on MATLAB MEX functions. In order to use MEX functions, you should setup mex correctly.

- Select a C compiler for the MATLAB version and the operation systems installed on your computer. For a list of MATLAB supported compiler, visit [here](http://www.mathworks.com/support/sysreq/previous_releases.html)

- Setup MEX by typing the following MATLAB command

```
      mex -setup 
```

- To ensure you have MEX installed appropriately, try an example provided by MATLAB:

```
	copyfile([matlabroot,'/extern/examples/mex/arraySize.c'],'./','f')
	mex -v arraySize.c
	arraySize(5000)
```
You would be able to see the size of a 5000 x 5000 matrix.

###STEP 2: Try the example problem given by mexBBFMM2D

- [Download the package from this link](https://www.dropbox.com/sh/ba9mt40msyy673t/dwAZAIb35f).

- Go to the folder containing `mexFMM2D.cpp`, and type Matlab command  

```
      callmxFMM2D
```

The output `QHexact` is the exact product of a 10000 x 10000 covariance matrix `Q` with kernel ![equation](http://latex.codecogs.com/gif.latex?Q%28h%29%20%3D%20%5Cexp%28-%5Cdfrac%7B%5Csqrt%7Bh%7D%7D%7B30%7D%29) and a 10000 x 100 matrix `H`. And `QH` is the product computed using BBFMM2D package. The relative difference of `QH` and `QHexact` is __3.2E-10__. The table below shows computation time on a single core CPU.

|   N      |  Time in seconds  |     
| -------: |:-----------------:|   
| 10,000   |                2.6|
| 100,000  |               27.3|  
| 1000,000 |              242.5|   

### Step 3: Use mexBBFMM2D for your own research problem:

1.Compile: Go to the folder __mexBBFMM2D/__ 
```
      syms r                     % r is seperation 
      kernel = exp(-r/30);       % specify kernel type
      make(r,kernel,'expfun')    % compile and generate the mex file with name 'expfun'
```

2.You should find __expfun.mex__ in your folder. Now if you want to compute a matrix-matrix product Q*H, move __expfun.mex__ to the desired directory you are working on. You can use it as an ordinary MATLAB function by including the following code to your script

```
      clear QH;                           % Must clear memory associated with output
      QH = expfun(xloc,yloc,H,nCheb,print);       
```
  Or if you want to compare the result with exact product QHexact for smaller case to determine the least number of chebyshev nodes `nCheb` needed. Large `nCheb` will give greater accuracy but more time consuming. 
  ```
      [QH,QHexact] = expfun(xloc,yloc,H,nCheb, print);
```

3.For a new kernel type, repeat step 1 to 2. Otherwise step 1 can be skipped. 

#### This package uses:

1. [Eigen](http://eigen.tuxfamily.org/index.php?title=Main_Page)

2. [BBFMM2D](https://github.com/sivaramambikasaran/BBFMM2D)

#### Reference:
1. Sivaram Ambikasaran, Judith Yue Li, Peter K. Kitanidis, Eric Darve, Large-scale stochastic linear inversion using hierarchical matrices, Computational Geosciences, December 2013, Volume 17, Issue 6, pp 913-927 [link](http://link.springer.com/article/10.1007%2Fs10596-013-9364-0)
2. Judith Yue Li, Sivaram Ambikasaran, Eric F. Darve, Peter K. Kitanidis, A Kalman filter powered by H2-matrices for quasi-continuous data assimilation problems [link](https://www.dropbox.com/s/xxjdvixq7py4bhp/HiKF.pdf)
3. Saibaba, A., S. Ambikasaran, J. Li, P. Kitanidis, and E. Darve (2012), Application of hierarchical matrices to linear inverse problems in geostatistics, OGST Revue d’IFP Energies Nouvelles, 67(5), 857–875, doi:http://dx.doi.org/10.2516/ogst/2012064. [link](http://ogst.ifpenergiesnouvelles.fr/articles/ogst/abs/2012/05/ogst120061/ogst120061.html)
4. Fong, W., and E. Darve (2009), The black-box fast multipole method, Journal of Computational Physics, 228(23), 8712–8725.[link](http://www.logos.t.u-tokyo.ac.jp/~tau/Darve_bbfmm_2009.pdf)

<script type="text/javascript"
   src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
