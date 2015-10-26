1. Install mex
2. Compilation of mex-code (on Matlab console):
        mex CFLAGS="\$CFLAGS -fopenmp" LDFLAGS="\$LDFLAGS -fopenmp" ./mex/apply_pse.c

        mex CFLAGS="\$CFLAGS -fopenmp -std=c99" LDFLAGS="\$LDFLAGS -fopenmp" ./mex/apply_pse.c


For data typeds see 

edit([matlabroot '/extern/examples/mex/explore.c']);

#pragma omp parallel for
mex CFLAGS="\$CFLAGS -fopenmp -std=c99 -O1" LDFLAGS="\$LDFLAGS -fopenmp" ./mex/apply_pse.c