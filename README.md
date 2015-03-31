# DASoftware
============

This is a Matlab library of data assimilation methods developed to solve large-scale state-parameter estimation problems. Data assimilation approach has been widely used in geophysics, hydrology and numerical weather forecast to improve the forecast from a numerical model based on data sets collected in real time. Conventional approach like Kalman filter is computatioanlly prohibitive for large problems. The DASoftware(Rename) library takes advantage of advances in computatioanl science and consists of new data assimilation approach that is scalable for large-scale problems. The functions and examples are produced based on collabrated work on data assimialtion documented in the papers listed in the Reference section.

## Start with examples

We have provided the users linear and nonlinear state estimation problems to get familier with data assimilation methods provided in the library.  

### Example 1: Saetrom

### Example 2: LA

### Example 3: Tomography

## How to select methods

Here we show a diagram of the methods provided in the library.

|  Method  |  Assumptions                 |  Jacobian matrix|  Covariance matrix |   
| -------: |:----------------------------:|:------------------------: |:--------------|   
|  HiKF    | fast data acquisition/fixed H| no forward run| O(m) operations |
|          | random-walk forward model    | |  |
|  CSKF    |    smooth problem            | r forward run | O(m) operations|
|  SpecKF  | approximate uncertainty/fixed H| p forward run|  O(m) operations|

## Add your own example

## Add your own method
1. Change selectDA.m
2. Add your own function: SpecKF.m following the template given by CSKF.m
3. Add additional parameters specific to SpecKF in get_prmstruct.m
4. Make sure use the same variable name in class, param and text file

#### Reference:
1. Judith Yue Li, Sivaram Ambikasaran, Eric F. Darve, Peter K. Kitanidis, A Kalman filter powered by H2-matrices for quasi-continuous data assimilation problems [link](https://www.dropbox.com/s/xxjdvixq7py4bhp/HiKF.pdf)

2. Sivaram Ambikasaran, Judith Yue Li, Peter K. Kitanidis, Eric Darve, Large-scale stochastic linear inversion using hierarchical matrices, Computational Geosciences, December 2013, Volume 17, Issue 6, pp 913-927 [link](http://link.springer.com/article/10.1007%2Fs10596-013-9364-0)

3. Hojat

4.

5. 

<script type="text/javascript"
   src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>