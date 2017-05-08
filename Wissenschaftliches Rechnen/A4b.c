#include <stdio.h>

__global__ void add(float a, float b){
	int c = a+b;
	return c;
}

int main(){
	// create sequence as input
	int zahlenfolge[6];
	for (int i = 0; i<7; i++) {
		zahlenfolge[i] = i;
	}
	// allocate memory
	int size = sizeof(int);
	cudaMalloc((void **)&a, size);
    cudaMalloc((void **)&b, size);
    cudaMalloc((void **)&c, size);
    //
    add <<<1,1>>>(zahlenfolge[0], zahlenfolge[1]);
    add <<<1,1>>>(zahlenfolge[2], zahlenfolge[3]);
    add <<<1,1>>>(zahlenfolge[4], zahlenfolge[5]);	
	return 0;
}
