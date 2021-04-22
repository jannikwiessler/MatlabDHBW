/*
 * sfuntmpl_basic.c: Basic 'C' template for a level 2 S-function.
 *
 * Copyright 1990-2018 The MathWorks, Inc.
 */

/*
 * You must specify the S_FUNCTION_NAME as the name of your S-function
 * (i.e. replace sfuntmpl_basic with the name of your S-function).
 */

#define S_FUNCTION_NAME heatcond
#define S_FUNCTION_LEVEL 2

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */
#include "simstruc.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/* Error handling
 * --------------
 *
 * You should use the following technique to report errors encountered within
 * an S-function:
 *
 *       ssSetErrorStatus(S,"Error encountered due to ...");
 *       return;
 *
 * Note that the 2nd argument to ssSetErrorStatus must be persistent memory.
 * It cannot be a local variable. For example the following will cause
 * unpredictable errors:
 *
 *      mdlOutputs()
 *      {
 *         char msg[256];         {ILLEGAL: to fix use "static char msg[256];"}
 *         sprintf(msg,"Error due to %s", string);
 *         ssSetErrorStatus(S,msg);
 *         return;
 *      }
 *
 */

/*====================*
 * S-function methods *
 *====================*/

/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *    The sizes information is used by Simulink to determine the S-function
 *    block's characteristics (number of inputs, outputs, states, etc.).
 */
static void mdlInitializeSizes(SimStruct *S)
{

  int numOfStatesInX = (int)mxGetScalar(ssGetSFcnParam(S, 3)); // numOfCells in x direction
  int numOfStatesInY = (int)mxGetScalar(ssGetSFcnParam(S, 4)); // numOfCells in y direction

  ssSetNumSFcnParams(S, 6); /* Number of expected parameters */
  if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S))
  {
    /* Return if number of expected != number of actual parameters */
    return;
  }

  ssSetNumContStates(S, numOfStatesInX * numOfStatesInY);
  ssSetNumDiscStates(S, 0);

  if (!ssSetNumInputPorts(S, 1))
    return;
  ssSetInputPortWidth(S, 0, 1);
  ssSetInputPortRequiredContiguous(S, 0, true); /*direct input signal access*/
  /*
     * Set direct feedthrough flag (1=yes, 0=no).
     * A port has direct feedthrough if the input is used in either
     * the mdlOutputs or mdlGetTimeOfNextVarHit functions.
     */
  ssSetInputPortDirectFeedThrough(S, 0, 0);

  if (!ssSetNumOutputPorts(S, 1))
    return;
  ssSetOutputPortWidth(S, 0, numOfStatesInX * numOfStatesInY);

  ssSetNumSampleTimes(S, 1);
  ssSetNumRWork(S, 0);
  ssSetNumIWork(S, 0);
  ssSetNumPWork(S, 0);
  ssSetNumModes(S, 0);
  ssSetNumNonsampledZCs(S, 0);

  /* Specify the operating point save/restore compliance to be same as a 
     * built-in block */
  ssSetOperatingPointCompliance(S, USE_DEFAULT_OPERATING_POINT);

  ssSetOptions(S, 0);
}

/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    This function is used to specify the sample time(s) for your
 *    S-function. You must register the same number of sample times as
 *    specified in ssSetNumSampleTimes.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
  ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);
  ssSetOffsetTime(S, 0, 0.0);
}

#define MDL_INITIALIZE_CONDITIONS /* Change to #undef to remove function */
#if defined(MDL_INITIALIZE_CONDITIONS)
/* Function: mdlInitializeConditions ========================================
   * Abstract:
   *    In this function, you should initialize the continuous and discrete
   *    states for your S-function block.  The initial states are placed
   *    in the state vector, ssGetContStates(S) or ssGetRealDiscStates(S).
   *    You can also perform any other initialization activities that your
   *    S-function may require. Note, this routine will be called at the
   *    start of simulation and if it is present in an enabled subsystem
   *    configured to reset states, it will be call when the enabled subsystem
   *    restarts execution to reset the states.
   */
static void mdlInitializeConditions(SimStruct *S)
{
  double initialTemperature = 20.0;

  double *x0 = ssGetContStates(S);
  for (int i = 0; i < ssGetNumContStates(S); i++)
  {
    x0[i] = initialTemperature;
  }
}
#endif /* MDL_INITIALIZE_CONDITIONS */

#define MDL_START /* Change to #undef to remove function */
#if defined(MDL_START)
/* Function: mdlStart =======================================================
   * Abstract:
   *    This function is called once at start of model execution. If you
   *    have states that should be initialized once, this is the place
   *    to do it.
   */
static void mdlStart(SimStruct *S)
{
}
#endif /*  MDL_START */

/* Function: mdlOutputs =======================================================
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block.
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{

  double *x = ssGetContStates(S);
  int nOutputPorts = ssGetNumOutputPorts(S);
  //printf("num of outputports: %d\n", nOutputPorts);

  for (int i = 0; i < nOutputPorts; i++)
  {
    //printf("i: %d\n", i);
    double *y = (double *)ssGetOutputPortRealSignal(S, 0);
    int outputPortWidth = (int)ssGetOutputPortWidth(S, 0);

    for (int j = 0; j < outputPortWidth; j++)
    {
      y[j] = x[j];
    }
  }
}

#define MDL_UPDATE /* Change to #undef to remove function */
#if defined(MDL_UPDATE)
/* Function: mdlUpdate ======================================================
   * Abstract:
   *    This function is called once for every major integration time step.
   *    Discrete states are typically updated here, but this function is useful
   *    for performing any tasks that should only take place once per
   *    integration step.
   */
static void mdlUpdate(SimStruct *S, int_T tid)
{
}
#endif /* MDL_UPDATE */

#define MDL_DERIVATIVES /* Change to #undef to remove function */
#if defined(MDL_DERIVATIVES)
/* Function: mdlDerivatives =================================================
   * Abstract:
   *    In this function, you compute the S-function block's derivatives.
   *    The derivatives are placed in the derivative vector, ssGetdX(S).
   */
static void mdlDerivatives(SimStruct *S)
{
  double cp = 439.0;    //J/molK
  double rho = 7874.0;  //kg/m3
  double lambda = 80.0; // W/m2K

  double *u = (double *)ssGetInputPortSignal(S, 0);
  double *x = (double *)ssGetContStates(S);
  double *dx = (double *)ssGetdX(S);

  double length = mxGetScalar(ssGetSFcnParam(S, 0));           // m in x direction
  double width = mxGetScalar(ssGetSFcnParam(S, 1));            // m in y direction
  double height = mxGetScalar(ssGetSFcnParam(S, 2));           // m in z direction
  int numOfStatesInX = (int)mxGetScalar(ssGetSFcnParam(S, 3)); // numOfCells in x direction
  int numOfStatesInY = (int)mxGetScalar(ssGetSFcnParam(S, 4)); // numOfCells in y direction
  int numOfStatesInZ = (int)mxGetScalar(ssGetSFcnParam(S, 5)); // numOfCells in y direction

  int numOfStates = (int)ssGetNumContStates(S);

  double deltax = length / numOfStatesInX;
  double deltay = width / numOfStatesInY;
  double deltaz = height / numOfStatesInZ;

  double *QdotxZu = (double *)malloc(sizeof(double) * numOfStates);
  double *QdotxAb = (double *)malloc(sizeof(double) * numOfStates);
  double *QdotyZu = (double *)malloc(sizeof(double) * numOfStates);
  double *QdotyAb = (double *)malloc(sizeof(double) * numOfStates);
  double *QdotAb = (double *)malloc(sizeof(double) * numOfStates);
  double *QdotZu = (double *)malloc(sizeof(double) * numOfStates);

  for (int i = 0; i < numOfStates; i++) // init the heat fluxes with zero
  {
    QdotxZu[i] = 0.0;
    QdotxAb[i] = 0.0;
    QdotyZu[i] = 0.0;
    QdotyAb[i] = 0.0;
    QdotAb[i] = 0.0;
    QdotZu[i] = 0.0;
  }

  for (int i = 1; i < numOfStatesInX - 1; i++)
  { // RB left and right
    x[i] = x[i + numOfStatesInX];
    x[numOfStatesInX * (numOfStatesInY - 1) + i] = x[numOfStatesInX * (numOfStatesInY - 2) + i];
  }

  for (int i = 1; i < numOfStatesInY - 1; i++)
  {                                                                    // RB up and down
    x[numOfStatesInX * i] = x[numOfStatesInX * i + 1];                 // up
    x[(i + 1) * numOfStatesInX - 1] = x[(i + 1) * numOfStatesInX - 2]; // down
  }

  printf("Simtime: %lf", (double)ssGetT(S));
  printf(", input: %lf\n", u[0]);
  QdotZu[(int)floor(numOfStatesInX * (numOfStatesInY / 2) + (numOfStatesInY / 2))] = u[0]; // W

  for (int i = 1; i < numOfStatesInY - 1; i++) // calc heat flux (loop in y - length direction)
  {
    for (int j = 1; j < numOfStatesInX - 1; j++) // loop in x - width direction
    {
      QdotyZu[numOfStatesInX * i + j] = -lambda * deltax * deltaz * (x[numOfStatesInX * i + j] - x[numOfStatesInX * (i - 1) + j]) / deltay;
      QdotyAb[numOfStatesInX * i + j] = -lambda * deltax * deltaz * (x[numOfStatesInX * (i + 1) + j] - x[numOfStatesInX * i + j]) / deltay;
      QdotxZu[numOfStatesInX * i + j] = -lambda * deltay * deltaz * (x[numOfStatesInX * i + j] - x[numOfStatesInX * i + (j - 1)]) / deltax;
      QdotxAb[numOfStatesInX * i + j] = -lambda * deltay * deltaz * (x[numOfStatesInX * i + (j + 1)] - x[numOfStatesInX * i + j]) / deltax;
    }
  }

  for (int i = 0; i < numOfStates; i++)
  {
    dx[i] = 1.0 / (cp * rho * deltax * deltay * deltaz) * (QdotxZu[i] - QdotxAb[i] + QdotyZu[i] - QdotyAb[i] + QdotZu[i] - QdotAb[i]);
  }

  free(QdotxZu);
  free(QdotxAb);
  free(QdotyZu);
  free(QdotyAb);
  free(QdotAb);
  free(QdotZu);
}
#endif /* MDL_DERIVATIVES */

/* Function: mdlTerminate =====================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.  For example, if memory was
 *    allocated in mdlStart, this is the place to free it.
 */
static void mdlTerminate(SimStruct *S)
{
}

/*=============================*
 * Required S-function trailer *
 *=============================*/

#ifdef MATLAB_MEX_FILE /* Is this file being compiled as a MEX-file? */
#include "simulink.c"  /* MEX-file interface mechanism */
#else
#include "cg_sfun.h" /* Code generation registration function */
#endif
