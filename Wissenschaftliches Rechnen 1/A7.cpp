#include <iostream>
#include <stdlib.h>
#include <xmmintrin.h>
#include "pmmintrin.h"

float reciproc_seriell(float a, float start, int iter){
	float x_old = start;
	float x_new;
	float f_x_old;
	float dev_x_old;	
	for (int i=0;i<iter;i++){
		f_x_old = 1/x_old - a;
		dev_x_old = - 1/(x_old*x_old);
		x_new = x_old - (f_x_old / dev_x_old);
		x_old = x_new;
		//std::cout << x_new << std::endl;		
	}
	return x_new;
}

float reciproc_sse(float* a, float* start){

	float* x_new;


	posix_memalign((void**)&x_new, 128, sizeof(float)*4);


	__m128 a_elements = _mm_load_ps(a);
	__m128 start_elements = _mm_load_ps(start);


	// x_neu = -ax^2 + 2x
	
	// mm_mul_ps(a_elements,b_elements);
	//_mm_add_ps(res_elements , ab_elements);
	//__m128 _mm_sub_ps (__m128 a, __m128 b)
	

	return a[0];
}


int main() {
	//std::cout << reciproc_seriell(5,0.1,3) << std::endl;
	
	float * a;
	float * start;
	posix_memalign((void**)&a, 128, sizeof(float)*4);
	posix_memalign((void**)&start, 128, sizeof(float)*4);

	a[0] = 2;
	a[1] = 3;
	a[2] = 4;
	a[3] = 5;
	start[0] = 0.1;
	start[1] = 0.1;
	start[2] = 0.1;
	start[3] = 0.1;

	//std::cout << reciproc_sse(a,start) << std::endl;
	reciproc_sse(a,start);

}
