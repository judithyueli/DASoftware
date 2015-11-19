/*=================================================================
 * arraySize.c - example used to illustrate memory requirements 
 * of large mxArrays. 
 *
 * Input: Length of square matrix
 * Output: Approximate memory required for matrix (optional)
 *
 * Creates and destroys a square mxArray of uint8 values and  
 * displays the approximate size of the matrix in kilobytes.
 *
 * Copyright 2007-2011 The MathWorks, Inc.
 *=================================================================*/

#include "mex.h"
void errorCheck(int nlhs, int nrhs, const mxArray *prhs[]);

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    double dim; 
    mxArray *theArray;
    double sizeOfDataInKilobytes;
    size_t numberOfElements;

    errorCheck(nlhs, nrhs, prhs);

    dim = mxGetScalar(prhs[0]);
    
    /* Create an mxArray of size dim x dim of type uint8.*/
    theArray = mxCreateNumericMatrix((mwSize)dim, (mwSize)dim, mxUINT8_CLASS, mxREAL);

    /* Display the mxArray's dimension. */
    mexPrintf("\nDimensions: %" FMT_SIZE_T "u x %" FMT_SIZE_T "u\n", mxGetM(theArray), mxGetN(theArray));

    /* Display the mxArray's size. */
    numberOfElements = mxGetNumberOfElements(theArray);
    /* numberOfElements can be converted to a double without loss of 
     precision because the maximum size of an array is 2^48-1. */
    sizeOfDataInKilobytes = numberOfElements * mxGetElementSize(theArray) / 1024.0;
    mexPrintf("Size of array in kilobytes: %.0f\n\n", sizeOfDataInKilobytes);

    /* Return result only if one is requested. */
    if ( nlhs == 1 ) {
        plhs[0] = mxCreateDoubleScalar(sizeOfDataInKilobytes);
    }
    
    mxDestroyArray(theArray);
}


void errorCheck(int nlhs, int nrhs, const mxArray *prhs[]){
    double dim;
    
	/* Check for proper number of arguments. */
    if ( nrhs != 1 || mxIsNumeric(prhs[0]) == 0 || mxGetNumberOfElements(prhs[0]) != 1 ) {
        mexErrMsgIdAndTxt("MATLAB:arraySize:rhs",
                "This function requires one scalar numeric input.");
    } 

    dim = mxGetScalar(prhs[0]);

    if ( dim < 0 ) {
        mexErrMsgIdAndTxt("MATLAB:arraySize:dimensionNegative",
                "The input dimension must be positive.");
    }

#if !defined(MX_COMPAT_32)
    /* Make sure that it is safe to cast dim to mwSize when using largeArrayDims.*/
    if ( dim > MWSIZE_MAX ) {
        mexErrMsgIdAndTxt("MATLAB:arraySize:dimensionTooLarge",
                "The input dimension, %.0f, is larger than the maximum value of mwSize, %u, when built with largeArrayDims.", dim, MWSIZE_MAX);
    }
#endif
 
    if ( nlhs > 1 ) {
        mexErrMsgIdAndTxt("MATLAB:arraySize:lhs","Too many output arguments.");
    }
    
 }
