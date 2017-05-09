#include <stdio.h>
#include <cuda.h>
#include <math.h>

//device code
__global__ void add(int a[], int c[]){
	int index = threadIdx.x + blockIdx.x * blockDim.x;
	int c[index] = a[2*index]+a[2*index+1];
	
}

__global__ void set_new_input(int new_input[], int old_output[]){
	int index = threadIDx.x + blockIdx.x * blockDim.x;
	new_input[index] = old_output[index];

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
	// variablen vorher definieren
	int *d_input;
	int *d_output;
	int size = sizeof(zahlenfolge);
	cudaMalloc((void **)&d_input, size);
    cudaMalloc((void **)&d_output, size/2);
    // initialize variables for loop
    int h_input [] = zahlenfolge;
    int input_length = length;
    int h_output[length/2];
    // Copy array from host to device
    cudaMemcpy (d_input, h_input,length*sizeof(int)), cudaMemcpyHostToDevice);
    cudaMemcpy (d_output, h_output,length*sizeof(int)), cudaMemcpyHostToDevice);
    // invoke kernel
    // Annahme: Länge der Eingabe ist 2er-Potenz
    for (int i = 0; i< log2(length);i++) {
		add <<<1,input_length/2>>>(&d_input,&d_output);
		// update variables for next loop instance
		set_new_input <<<1,input_length/2>>>(&d_input,&d_output);
		input_length = sizeof(d_input)/sizeof(d_input[0]);
	}
	// Copy result from device to host
	cudaMemcpy (h_output, d_output, length*sizeof(int), cudaMemcpyDeviceToHost);

	printf("Praefixsumme:%a",h_output[0]);
	
	// Free device memory
	cudaFree(d_input);
	cudaFree(d_output);
	
	return 0;
}
