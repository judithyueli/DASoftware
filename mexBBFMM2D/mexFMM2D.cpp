/*
The MATLAB gateway function to BBFMM2D developed by Sivaram.
The code provides a O(N) solution to a kernel matrix-vector product.
Written by Judith Yue Li 10/02/2013
*/

#include <iostream>
#include "math.h"
#include "mex.h"
#include "matrix.h"
#include "environment.hpp"
#include "BBFMM2D.hpp"
#include <Eigen/Core>
#include "kernelfun.hpp"

using namespace Eigen;
using namespace std;
double pi 	=	4.0*atan(1.0);
extern void _main();

#define IS_REAL_2D_FULL_DOUBLE(P) (!mxIsComplex(P) && mxGetNumberOfDimensions(P) == 2 && !mxIsSparse(P) && mxIsDouble(P))
#define IS_REAL_SCALAR(P) (IS_REAL_2D_FULL_DOUBLE(P) && mxGetNumberOfElements(P) == 1)

// Pass location from matlab to C
void read_location(const mxArray* x, const mxArray* y, vector<Point>& location){
    unsigned long N;
    double *xp, *yp;
    N = mxGetM(x);
    xp = mxGetPr(x);
    yp = mxGetPr(y);
    for (unsigned long i = 0; i < N; i++){
        Point new_Point;
        new_Point.x = xp[i];
        new_Point.y = yp[i];
        location.push_back(new_Point);
    }
}

void mexFunction(int nlhs,mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    // Macros for the output and input arguments
    #define QH_OUT          plhs[0]
    #define QHexact_OUT     plhs[1]
    #define x_IN            prhs[0]
    #define y_IN            prhs[1]
    #define H_IN            prhs[2]
    #define nCheb_IN        prhs[3]
    #define print_IN        prhs[4]

    unsigned long N;
    unsigned m;
    
    // Argument Checking:

    // Check number of argument
    if(nrhs != 5) {
        mexErrMsgTxt("Wrong number of input arguments");
    }else if(nlhs > 2){
        mexErrMsgTxt("Too many output arguments");
    }

    if( !IS_REAL_2D_FULL_DOUBLE(x_IN)) {
        mexErrMsgTxt("Third input argument is not a real 2D full double array.");
    }
    if( !IS_REAL_2D_FULL_DOUBLE(y_IN)) {
        mexErrMsgTxt("Third input argument is not a real 2D full double array.");
    }
    if( !IS_REAL_2D_FULL_DOUBLE(H_IN)) {
        mexErrMsgTxt("Third input argument is not a real 2D full double array.");
    }
    if( !IS_REAL_SCALAR(nCheb_IN)){
        mexErrMsgTxt("nChebnotes must be a real double scalar");
    }
    if( mxGetM(x_IN)!= mxGetM(y_IN) || mxGetM(x_IN) != mxGetM(H_IN)){
        mexErrMsgTxt("The dimension of the input matrices is wrong");
    }
    
    //processing on input arguments
    N = mxGetM(H_IN); // get the first dimension of H
    m = mxGetN(H_IN); // get the second dimension of H
    unsigned short nChebNodes = *mxGetPr(nCheb_IN);
    bool print = *mxGetPr(print_IN);
    vector<Point> location;
    read_location(x_IN,y_IN,location);
    double *charges;
    charges = mxGetPr(H_IN);
    // Load data to local array using Eigen <Map>
    MatrixXd H = Map<MatrixXd>(charges, N, m); // Map<MatrixXd> H(charges,N,m);
    
    // Compute Fast matrix vector product
    // 1. Build Tree
    clock_t startBuild  = clock();
    H2_2D_Tree Atree(nChebNodes, charges, location, N, m, print); //Build the fmm tree
    clock_t endBuild = clock();

    double FMMTotalTimeBuild = double(endBuild-startBuild)/double(CLOCKS_PER_SEC);
    if(print)
        mexPrintf("\nTime taken for FMM(build tree) is: %.4g\n",FMMTotalTimeBuild);    
    
    // 2.Calculateing potential
    clock_t startA = clock();
    // Create the output matrix
    QH_OUT = mxCreateDoubleMatrix(N, m, mxREAL);     
    // Get a pointer to the real data in the output matrix
    double *QHp;
    QHp = mxGetPr(QH_OUT);
    myKernel A;
    A.calculate_Potential(Atree, QHp);
    clock_t endA = clock();
    double FMMTotalTimeA = double(endA-startA)/double(CLOCKS_PER_SEC);
    if(print){
        mexPrintf("\nTime taken for FMM(calculating potential) is: %.4g\n",FMMTotalTimeA);
        mexPrintf("\nTotal time taken for FMM is: %.4g\n",FMMTotalTimeA+FMMTotalTimeBuild);
    }

    /*///////////////////////////////
    // Compute exact covariance Q //
    ///////////////////////////////*/

    if(nlhs == 2){
    if(print){    
        mexPrintf("\nStarting exact computation...\n");
    }
    clock_t start = clock();
    MatrixXd Q;
    A.kernel_2D(N, location, N, location, Q);// Q is initialized inside function A.kernel_2D
    clock_t end = clock();
    double exactAssemblyTime = double(end-start)/double(CLOCKS_PER_SEC);
    
    // Compute exact Matrix vector product
    start = clock();
    QHexact_OUT = mxCreateDoubleMatrix(N, m, mxREAL);
    double *QHexactp;
    QHexactp = mxGetPr(QHexact_OUT);
    Map<MatrixXd> QHT(QHexactp,N,m);
    QHT = Q*H;
    end = clock();
    double exactComputingTime = double(end-start)/double(CLOCKS_PER_SEC);
    if(print){    
        mexPrintf("\nThe total exact computation time is: %.4g\n",exactAssemblyTime + exactComputingTime);
    }
        
    // Compute the difference
    MatrixXd QHfast = Map<MatrixXd>(QHp, N, m);
    MatrixXd error = QHfast - QHT;
    double absoluteError = error.norm();
    double relativeError = absoluteError/QHT.norm();
    if(print){    
        mexPrintf("The relative difference is: %13.6E \n", relativeError);
    }
    } 

    return;
}
