/**
 * Copyright 2011 B. Schauerte. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are 
 * met:
 * 
 *    1. Redistributions of source code must retain the above copyright 
 *       notice, this list of conditions and the following disclaimer.
 * 
 *    2. Redistributions in binary form must reproduce the above copyright 
 *       notice, this list of conditions and the following disclaimer in 
 *       the documentation and/or other materials provided with the 
 *       distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY B. SCHAUERTE ''AS IS'' AND ANY EXPRESS OR 
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
 * DISCLAIMED. IN NO EVENT SHALL B. SCHAUERTE OR CONTRIBUTORS BE LIABLE 
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *  
 * The views and conclusions contained in the software and documentation
 * are those of the authors and should not be interpreted as representing 
 * official policies, either expressed or implied, of B. Schauerte.
 */

/** 
 * Helper to faster calculate the AUC using AUC.m
 * 
 * How to compile in Matlab:
 *   mex -D__MEX auc_steps_helper.cpp
 * 
 * If you use any of this work in scientific research or as part of a larger 
 * software system, you are kindly requested to cite the use in any related 
 * publications or technical documentation. The work is based upon:
 *
 *   B. Schauerte, and R. Stiefelhagen, "Quaternion-based Spectral Saliency
 *   Detection for Eye Fixation Prediction," in 12th European Conference on 
 *   Computer Vision (ECCV), 2012.
 *
 *   B. Schauerte, and R. Stiefelhagen, "Predicting Human Gaze using 
 *   Quaternion DCT Image Signature Saliency and Face Detection," in IEEE 
 *   Workshop on the Applications of Computer Vision (WACV), 2012.  
 *
 * \author B. Schauerte
 * \email  <schauerte@kit.edu>
 * \date   2011
 */
#include <cmath>

#ifdef __MEX
#define __CONST__ const
#include "mex.h"
#include "matrix.h"
#endif

#ifdef __MEX
template <typename T>
void
_mexFunction(int nlhs, mxArray* plhs[],
             int nrhs, const mxArray* prhs[])
{
  const mxClassID inputClass = mxGetClassID(prhs[0]);
  
  // create aliases
  __CONST__ mxArray *mxa     = prhs[0];
  __CONST__ mxArray *mxb     = prhs[1];
  __CONST__ mxArray *mxsteps = prhs[2];
  // get the data pointers
  size_t numel_a     = mxGetNumberOfElements(mxa);
  size_t numel_b     = mxGetNumberOfElements(mxb);
  size_t numel_steps = mxGetNumberOfElements(mxsteps);

  // check for invalid data types
  if (mxIsComplex(mxa))
    mexErrMsgTxt("only real data allowed");

  // create the output data    
  mxArray *mxR = mxCreateNumericMatrix(numel_steps+1,2,inputClass,mxREAL); //mxCreateDoubleMatrix(numel_steps+1, 2, mxREAL); 
  plhs[0] = mxR;

  __CONST__ T* a     = (T*)mxGetData(mxa);
  __CONST__ T* b     = (T*)mxGetData(mxb);
  __CONST__ T* steps = (T*)mxGetData(mxsteps);
  T* R               = (T*)mxGetData(mxR);
  
  const T la(numel_a); // length(a)
  const T lb(numel_b); // length(b)
  for (size_t i = 0; i < numel_steps; i++) // for ii = asteps
  {
    const T ii = steps[i];
    
    ///
    // Calculate tp and fp
    ///
    
    size_t ctp = 0; 
    size_t cfp = 0;
    
    for (size_t k = 0; k < numel_a; k++)
      if (a[k] >= ii)
        ++ctp;
    
    for (size_t k = 0; k < numel_b; k++)
      if (b[k] >= ii)
        ++cfp;

    T ltp(ctp); // length(tp)
    T lfp(cfp); // length(fp)
    
    ///
    // Calculate the ratio
    ///
    
    R[i] = lfp / lb;
    R[(numel_steps+1) + i] = ltp / la;
  }
  R[numel_steps] = 0;
  R[(numel_steps+1) + numel_steps] = 0;
}

void
mexFunction(int nlhs, mxArray* plhs[],
            int nrhs, const mxArray* prhs[])
{
  // check number of input parameters
  if (nrhs != 3)
    mexErrMsgTxt("Input: a b steps");

  // Check number of output parameters
  if (nlhs > 1) 
    mexErrMsgTxt("output: R");

  // only float and double are currently supported
  if (!mxIsDouble(prhs[0]) && !mxIsSingle(prhs[0])) 
  	mexErrMsgTxt("Only float and double input arguments are supported.");
  
  // @todo: check that a, b, and steps have the same data type
  
  switch (mxGetClassID(prhs[0]))
  {
    case mxDOUBLE_CLASS:
      _mexFunction<double>(nlhs,plhs,nrhs,prhs);
      break;
    case mxSINGLE_CLASS:
      _mexFunction<float>(nlhs,plhs,nrhs,prhs);
      break;
    default:
      // this should never happen
      break;
  }
}
#endif
