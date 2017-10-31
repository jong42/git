#include <stdio.h>
#include <cuda.h>

//device code
//Gemeinsamer Speicher der Threads
//__shared__ float c[1024];

__global__ void mykernel(float *a,float *b,float *c) {
// perform calculation
int index = threadIdx.x + blockIdx.x *blockDim.x;
c[index] = a[index]*b[index];
//printf("%f\n",c[index]);
// Barriere zur Synchronisation von Threads
__syncthreads();
}

//host
int main (){
	
	//Allocate vectors in host memory
	int threadnr = 1024;
	float n = 524288;
	float *h_a, *h_b, *h_c;
	h_a = (float *)malloc(sizeof(float) * n);
	h_b = (float *)malloc(sizeof(float) * n);
	h_c = (float *)malloc(sizeof(float) * n);
	
	//Create vector values
	int i;
	for (i=0;i<n;i++)
		{
			h_a[i] = i+1;
			h_b[i] = n-i;
		}
	
	//Allocate vectors in device memory
	float *d_a, *d_b, *d_c;
	cudaMalloc((void **)&d_a, n*sizeof(float));
	cudaMalloc((void **)&d_b, n*sizeof(float));
	cudaMalloc((void **)&d_c, n*sizeof(float));
	//Copy vectors from host memory to device memory
	cudaMemcpy(d_a, h_a, n*sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, h_b, n*sizeof(float), cudaMemcpyHostToDevice);

	//Invoke kernel
	mykernel<<<n/threadnr, threadnr>>>(d_a, d_b, d_c);
	//Copy result from device memory to host memory
	cudaMemcpy(h_c, d_c, n*sizeof(float), cudaMemcpyDeviceToHost);
	// Free device memory
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	
	// calculate sum of al c elements
	float sum = 0;	
	for (i=0;i<n;i++)
		{ 
			sum = sum + h_c[i];
		}

	printf("sum: %f\t", sum);
	
	return 0;
}

