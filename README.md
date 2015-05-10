# DASoftware
============

This is a Matlab library of data assimilation methods developed to solve large-scale state-parameter estimation problems. Data assimilation approach has been widely used in geophysics, hydrology and numerical weather forecast to improve the forecast from a numerical model based on data sets collected in real time. Conventional approach like Kalman filter is computatioanlly prohibitive for large problems. The DASoftware library takes advantage of advances in computatioanl science and consists of new data assimilation approach that is scalable for large-scale problems. The functions and examples are produced based on collabrated work on data assimialtion documented in the papers listed in the Reference section.

**This is an ongoing project. The library is incomplete.** 


## Start with examples

We have provided the users linear and nonlinear state estimation problems to get familier with data assimilation methods provided in the library. All the built-in examples can be operated using a simple one-line code with an input file (*.txt) including all the assimilation parameters.  

- Run a 1-D linear state estimation example (Sætrom & Omre 2011) with Kalman filter  
```
[sol,true]=main('prm-saetrom.txt')
```
- Figure shows the mean and 95% confidence interval at intial and final time step.

![KF image](https://github.com/judithyueli/DASoftware/blob/master/image/KF-Saetrom.png)

- Run the same problem using CSKF (Li et al. 2015) with \\N = 50\\ basis
```
[sol,true]=main('prm-saetrom-cskf.txt')
```

## Summary of Example
| Example  | Dimension | Linearity | Specific |
| -------: |:---------:|:----------|:--------:|
| Saetrom  | 1D        | Linear    | F(x,t)   |

## Summary of methods

Here we show a diagram of the methods provided in the library.

|  Method  |  Assumptions                 |  Jacobian matrix|  Covariance matrix |   
| -------: |:----------------------------:|:------------------------: |:--------------|   
|  HiKF    | fast data acquisition/fixed H| no forward run| O(m) operations |
|          | random-walk forward model    | |  |
|  CSKF    |    smooth problem            | r forward run | O(m) operations|
|  SpecKF  | approximate uncertainty/fixed H| p forward run|  O(m) operations|
|  EnKF    | monte carlo based approach   | r forward run | O(m) operations|


#### Reference:
1. Judith Yue Li, Sivaram Ambikasaran, Eric F. Darve, Peter K. Kitanidis, A Kalman filter powered by H2-matrices for quasi-continuous data assimilation problems [link](https://www.dropbox.com/s/xxjdvixq7py4bhp/HiKF.pdf)

2. Sivaram Ambikasaran, Judith Yue Li, Peter K. Kitanidis, Eric Darve, Large-scale stochastic linear inversion using hierarchical matrices, Computational Geosciences, December 2013, Volume 17, Issue 6, pp 913-927 [link](http://link.springer.com/article/10.1007%2Fs10596-013-9364-0)

3. Ghorbanidehno, H., A. Kokkinaki, J. Y. Li, E. Darve, and P. K. Kitanidis, 2014. Real time data
assimilation for large-scale systems with the Spectral Kalman Filter: An application in CO2
storage monitoring, Submitted to Advances in Water Resources, Special issue on data
assimilation (under review)

4. Judith Yue Li, A. Kokkinaki, H. Ghorbanidehno, E. Darve, and P. K. Kitanidis, 2015. The nonlinear compressed state Kalman filter for efficient large-scale reservoir monitoring, Submitted to Water Resources Research (under review)

5. Sætrom, J., & Omre, H. (2011). Ensemble Kalman filtering with shrinkage regression techniques. Computational Geosciences, 15(2), 271–292.

[ref2]: https://www.dropbox.com/s/3wrsljtlq0ub65p/KF-Saetrom.png?dl=0 "KF image"

<script type="text/javascript"
   src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>