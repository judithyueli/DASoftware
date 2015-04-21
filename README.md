# DASoftware
============

This is a Matlab library of data assimilation methods developed to solve large-scale state-parameter estimation problems. Data assimilation approach has been widely used in geophysics, hydrology and numerical weather forecast to improve the forecast from a numerical model based on data sets collected in real time. Conventional approach like Kalman filter is computatioanlly prohibitive for large problems. The DASoftware(Rename) library takes advantage of advances in computatioanl science and consists of new data assimilation approach that is scalable for large-scale problems. The functions and examples are produced based on collabrated work on data assimialtion documented in the papers listed in the Reference section.

## Task list
- User interface
	- Add text file input [x]
	- A github note [x] 
- Method
	- Add KF method [x]
	- __Add CSKF method__
		- change getFU and getHU by using getJv (4/21)
	- __Add EnKF method__
	- __Add SpecKF method__
		- Test SpecKF using linear Saetrom example (4/21)
		- Add `Jv = getJv(f,v)`, a general routine to compute the product of Jacobian of function f(x) with vector v
		- Change PFH and PH
	- Add Abstract Class DA for method [x]
- Example
	- Add Saetrom example []
		- Linear f(x) [x]
		- Nonlinear f(x) []
	- __Add Saetrom nonlinear example__
	- Add LA example (linear, 1D, with parameter)
	- Add Abstract Class for examples
	- Add Tomography example
- Functionality
	- Add plot tools []
		- Add a routine for initial and final step [x]
	- Add Class for compressing a kernel matrix, generate realizations from a kernel matrix and...
	- Add inferential statistics like CR, Q2, normalized residual

## Start with examples

We have provided the users linear and nonlinear state estimation problems to get familier with data assimilation methods provided in the library.  
```
[sol,true]=main('prm-saetrom.txt')
```
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
|  EnKF    | monte carlo based approach   | r forward 
run | O(m) operations|

## Add your own example
1. Change selectFW.m
2. Add your own class: LA.m  (see template given by Saetrom.m)
3. Reuse the properties and methods as many as possible and make sure use the same variable name in class, param structure and text file
4. Do not commit changes before you test your code on your local branch

## Add your own method
1. Change selectDA.m
2. Add your own class: SpecKF.m (see template given by CSKF.m)
3. Add additional parameters specific to SpecKF in get_prmstruct.m
4. Make sure use the same variable name in class, param and text file
5. Do not commit changes before you test your code on your local branch

## How to collaborate using Github (desktop version)
1. create your own branch: HojatBranch (or other name you want to give to your local branch, note that it is different from creating a new repository)
- To create a new branch off of the master branch, click the + button on the left side of the branch name. Type a name for your new branch into the text field that appears, and click Branch to create it.
2. click "publish" so it shows up in github website
3. make sure HojatBranch is the current branch before you commit changes-> i.e., you commit to your local branch instead of the master branch
4. send a pull request: [link](https://help.github.com/articles/using-pull-requests/)
- an email will be sent to all 3 of us (all contributors)
5. together we can review the request and decide whether to merge or not

#### Reference:
1. Judith Yue Li, Sivaram Ambikasaran, Eric F. Darve, Peter K. Kitanidis, A Kalman filter powered by H2-matrices for quasi-continuous data assimilation problems [link](https://www.dropbox.com/s/xxjdvixq7py4bhp/HiKF.pdf)

2. Sivaram Ambikasaran, Judith Yue Li, Peter K. Kitanidis, Eric Darve, Large-scale stochastic linear inversion using hierarchical matrices, Computational Geosciences, December 2013, Volume 17, Issue 6, pp 913-927 [link](http://link.springer.com/article/10.1007%2Fs10596-013-9364-0)

3. Ghorbanidehno, H., A. Kokkinaki, J. Y. Li, E. Darve, and P. K. Kitanidis, 2014. Real time data
assimilation for large-scale systems with the Spectral Kalman Filter: An application in CO2
storage monitoring, Submitted to Advances in Water Resources, Special issue on data
assimilation (under review)

4. Judith Yue Li, A. Kokkinaki, H. Ghorbanidehno, E. Darve, and P. K. Kitanidis, 2015. The nonlinear compressed state Kalman filter for efficient large-scale reservoir monitoring, Submitted to Water Resources Research (under review)

<script type="text/javascript"
   src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>