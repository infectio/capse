/**
 * The following code just replaces runPSE.m of the original model
 * Due to ordinary code optimization and use of openMP it is already quite fast
 * Optimization is done without any linear Alg. libraries to keep the code as platform independent as possible
 */
#if defined(_WIN32) || defined(_WIN64)
    #define _WINDOWS
#endif

#ifdef _WINDOWS
        #include <omp.h>
        #define _USE_MATH_DEFINES
#endif        

#include <cmath>
#include <mex.h>

        
void show_openmp()
{
int nthreads, tid, procs, maxt, inpar, dynamic, nested;

// Start parallel region 
#pragma omp parallel private(nthreads, tid)
{

    // Obtain thread number    
    tid = omp_get_thread_num();

    // Only master thread does this    
    if (tid == 0) {
        printf("Thread %d getting environment info...\n", tid);

        // Get environment information 
        procs = omp_get_num_procs();
        nthreads = omp_get_num_threads();
        maxt = omp_get_max_threads();
        inpar = omp_in_parallel();
        dynamic = omp_get_dynamic();
        nested = omp_get_nested();

        // Print environment information 
        printf("Number of processors = %d\n", procs);
        printf("Number of threads = %d\n", nthreads);
        printf("Max threads = %d\n", maxt);
        printf("In parallel? = %d\n", inpar);
        printf("Dynamic threads enabled? = %d\n", dynamic);
        printf("Nested parallelism supported? = %d\n", nested);  
    }
}
}

void mexFunction(
    int nlhs, mxArray *plhs[],
    int nrhs, const mxArray *prhs[])
{ 
    //show_openmp(); // Show OpenMP info
    
    double epsilon = ((double)(mxGetScalar(prhs[0])));  // Importing epsilon from Matlab, used for calculations below
    //int strengthDim = ((int)(mxGetScalar(prhs[1])));   // Is not used at the moment
    int lenPartMat = ((int)(mxGetScalar(prhs[2])));     // Defines how long the partMat array is
    double *partMat = mxGetPr(prhs[3]);     // partMap as double pointer, we can read directly from Matlab array
    const mxArray* verletListCells = prhs[4];   // verletList from Matlab (the whole one)
    int numParts = mxGetM(verletListCells);     // number of cells in verletList
    
    plhs[0] = mxCreateDoubleMatrix(numParts,1,mxREAL);  // This is where we store the results
    double *pseSum = mxGetPr(plhs[0]);
    
    double epsilonSquared = epsilon*epsilon;    // We square that already to be faster (so we have to square it just one time)
    double preConst = 4.0/((epsilonSquared) * M_PI);    // This is used in calculations before. Because it is a constant, we compute that already here, just one time
    
    #pragma omp parallel for  // To run the following (outer) for-loop in parallel on multiple cores
    for(int i = 0; i < numParts; i++)
    {
        mxArray *verletList = mxGetCell(verletListCells,i);     // We get one cell of verletList
        double *verletListPtr = mxGetPr(verletList);        // We get a pointer to this single cell

        int numberVerlet = mxGetM(verletList);      // Get length of the array in that cell
        
        double preSum = 0;
        
        double tempVar0;    // Those two values could also be writen as an array, but two single variables could be faster (depending on comiler)
        double tempVar1;
    
        for(int a = 0; a < numberVerlet; a++)
        {
            int adress = ((int) (*(verletListPtr + a))) - 1;    // This is the same at three places in the inner for-loop, so we calculate it just one time and store it
            
            tempVar0 = partMat[adress] - partMat[i];    // **** START of the actual calculations ****
            tempVar1 = partMat[adress + lenPartMat] - partMat[i + lenPartMat];

            tempVar0 = tempVar0*tempVar0 + tempVar1*tempVar1;
            
            tempVar0 = preConst * exp(-(tempVar0/epsilonSquared));              
            preSum += ((partMat[adress + 2*lenPartMat] - partMat[i + (2*lenPartMat)]) * tempVar0);      // **** END of the actual calculations ****
        }
        
        pseSum[i] = preSum;     // It's faster to sum up in an local variable and then transfer it 
    }  
}
    
