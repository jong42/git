#include <stdio.h>
#include <cuda.h>
#include <math.h>

//device code
__global__ void add(int a[], int mod_val){
	int my_id = threadIdx.x + blockIdx.x * blockDim.x;
	if ((my_id%mod_val) == (mod_val-1))
	{
		a[my_id] += a[mod_val/2];
	}
	
	
}

//host code
int main(){
	// create sequence as input
	int zahlenfolge[8];
	for (int i = 0; i<8; i++) {
		zahlenfolge[i] = i+1;
	}
	length = sizeof(zahlenfolge)/sizeof(zahlenfolge[0]);
	// allocate memory
	int *d_output;
	int size = sizeof(zahlenfolge);
	cudaMalloc((void **)&d_output, size);
    // initialize variables for loop
    int h_output [] = zahlenfolge;
    // Copy array from host to device
    cudaMemcpy (d_output, h_output,length*sizeof(int)), cudaMemcpyHostToDevice);
    // invoke kernel
    for (int i = 0; i< log2(length);i++) {
		int mod_val = 2;
		add <<<1,input_length/mod_val>>>(&d_output, mod_val);
		// update variables for next loop instance
		mod_val *= 2;
	}
	// Copy result from device to host
	cudaMemcpy (h_output, d_output, length*sizeof(int), cudaMemcpyDeviceToHost);

	printf("Praefixsumme:%a",h_output);
	
	// Free device memory
	cudaFree(d_output);
	
	return 0;
}
