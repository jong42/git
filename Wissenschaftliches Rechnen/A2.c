#include <stdio.h>
#include <cuda.h>

//device code
//Gemeinsamer Speicher der Threads
__shared__ float c[1024];

__global__ void mykernel(a,b,c) {
// perform calculation
c = a*b;
}

// Barriere zur Synchronisation von Threads
__syncthreads();


//host
int main (){
	

	int n = 524288;
	int a[n];
	int b[n];
	
	int i;
	
	for (i=1;i<n;i++)
		{
			a[i] = i;
			b[i] = n-i;
			//printf("%d", a[i]);
			//printf("%d", b[i]);
		}
	
	//Allocate vectors in host memory
	int* h_a, h_b, h_c;
	h_a = (int *)malloc(sizeof(int) * 1024);
	h_b = (int *)malloc(sizeof(int) * 1024);
	h_c = (int *)malloc(sizeof(int) * n);
	
	//Allocate vectors in device memory
	int* d_a, d_b, d_c;
	cudaMalloc(&d_a, 1024*sizeof(int));
	cudaMalloc(&d_b, 1024*sizeof(int));
	cudaMalloc(&d_c, 1024*sizeof(int));
	//Copy vectors from host memory to device memory
	cudaMemcpy(d_a, h_a, 1024*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, h_b, 1024*sizeof(int), cudaMemcpyHostToDevice);
	//Invoke kernel
	Mykernel<<<512, 1024>>>(d_a, d_b, d_c);
	//Copy result from device memory to host memory
	cudaMemcpy(h_c, d_c, 1024*sizeof(int), cudaMemcpyDeviceToHost);
	// Free device memory
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
		
	return 0;
}

