// /usr/local/cuda/bin/nvcc -arch=sm_61 vdp.cu -o vdp
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <float.h>
#define N (524288)
//#define N (2097152)
//#define N (4194304)
#define THREADS_PER_BLOCK (128)
#define NUM_BLOCKS (N/THREADS_PER_BLOCK)

__global__ void dot_product(float *d_A, float *d_B, float *d_C){

    int index = threadIdx.x + blockIdx.x * blockDim.x;
    __shared__ float se[THREADS_PER_BLOCK];
    se[threadIdx.x] = (float)d_A[index] * d_B[index];
    __syncthreads();
    if (threadIdx.x == 0){
        float sum = 0;
        for (int i = 0; i < THREADS_PER_BLOCK;i++){

            sum += se[i];
        }
        // No time to waste
        atomicAdd(d_C,  sum);
    }
}

int main(){

    clock_t start, end;
    float cpu_time_used;

    float *h_A, *h_B, *d_A, *d_B;
    float *h_C, *d_C;
    int size = N * sizeof(float);
    cudaMalloc((void **)&d_A, size);
    cudaMalloc((void **)&d_B, size);
    cudaMalloc((void **)&d_C, sizeof(float));
    h_A = (float *)malloc(size);
    h_B = (float *)malloc(size);
    h_C = (float *)malloc(sizeof(float));

    // value creation for dot product
    for (int i = 0; i < N; i++){
        h_A[i] = i+1;
        h_B[i] = N-i;
    }
    *h_C = 0;

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_C, h_C, sizeof(float), cudaMemcpyHostToDevice);
    start = clock();
    dot_product<<< NUM_BLOCKS, THREADS_PER_BLOCK >> >(d_A, d_B, d_C);
    end = clock();
    cudaMemcpy(h_C, d_C, sizeof(float), cudaMemcpyDeviceToHost);
    cudaThreadExit();
    cpu_time_used = ((float) (end - start)) / CLOCKS_PER_SEC;
    printf("CUDA:\t\t%f in %f\n", *h_C, cpu_time_used);

    // Never trust CUDA
    start = clock();
    float sumCheck = 0;
    for (int i = 0; i < N; i++){

        sumCheck += (float)h_A[i] * h_B[i];
    }
    end = clock();
    cpu_time_used = ((float) (end - start)) / CLOCKS_PER_SEC;
    printf("CPU Check:\t%f in %f\n", sumCheck, cpu_time_used);
    free(h_A);
    free(h_B);
    free(h_C);
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
    return 0;
 }
