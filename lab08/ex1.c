#include "ex1.h"

void v_add_naive(double* x, double* y, double* z) {
    #pragma omp parallel
    {
        for(int i=0; i<ARRAY_SIZE; i++)
            z[i] = x[i] + y[i];
    }
}

// Adjacent Method
void v_add_optimized_adjacent(double* x, double* y, double* z) {
    // TODO: Implement this function
    // Do NOT use the `for` directive here!
    #pragma omp parallel
    {
        int n = omp_get_num_threads();
        int i = omp_get_thread_num();

        for (int j = i; j < ARRAY_SIZE; j += n) {
            z[j] = x[j] + y[j]; 
        }
    }
}

// Chunks Method
void v_add_optimized_chunks(double* x, double* y, double* z) {
    // TODO: Implement this function
    // Do NOT use the `for` directive here!
    #pragma omp parallel
    {
        int n = omp_get_num_threads();
        int i = omp_get_thread_num();
        int stride = ARRAY_SIZE / n;
        int start = i * stride;

        for (int j = 0; j < stride; j++) {
            z[start + j] = x[start + j] + y[start + j];
        }

        if (i == n - 1) {
            for (int j = stride * n; j < ARRAY_SIZE; j++) 
                z[j] = x[j] + y[j];
        }
    }
    
}
