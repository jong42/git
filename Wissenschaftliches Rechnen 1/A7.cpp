#include <iostream>
#include <stdlib.h>
#include <xmmintrin.h>
#include "pmmintrin.h"
#include <chrono>

using std::chrono::system_clock;
using std::chrono::duration;

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

float reciproc_sqrt_seriell(float a, float start, int iter){
	float x_old = start;
	float x_new;
	float f_x_old;
	float dev_x_old;	
	for (int i=0;i<iter;i++){
		f_x_old = 1/(x_old*x_old) - a;
		dev_x_old = - 2/(x_old*x_old*x_old);
		x_new = x_old - (f_x_old / dev_x_old);
		x_old = x_new;
		//std::cout << x_new << std::endl;		
	}
	return x_new;
}

__m128 reciproc_sse(__m128 a, __m128 start){

	__m128 res_1;
	__m128 res_2;
	__m128 res_3;
		
	// x_neu = -ax^2 + 2x
	res_1 = _mm_mul_ps(start,start);
	res_2 = -_mm_mul_ps(res_1,a);
	res_3 = _mm_add_ps(res_2 , 2*start);

	return res_3;
}

__m128 reciproc_sqrt_sse(__m128 a, __m128 start){

	__m128 res_1;
	__m128 res_2;
	__m128 res_3;
		
	// x_neu = -ax^3 + 3/2*x
	res_1 = _mm_mul_ps(_mm_mul_ps(start,start),start);
	res_2 = -_mm_mul_ps(res_1,a);
	res_3 = _mm_add_ps(res_2 , 1.5*start);

	return res_3;
}


int main() {
	float * a;
	float * start_val;
	posix_memalign((void**)&a, 16, sizeof(float)*4);
	posix_memalign((void**)&start_val, 16, sizeof(float)*4);
	
	a[0] = 2;
	a[1] = 3;
	a[2] = 4;
	a[3] = 5;

	__m128 a_elements = _mm_load_ps(a);
	__m128 start_elements = _mm_load_ps(start_val);
	start_elements = _mm_rcp_ps (a_elements);
	__m128 start_elements_sqrt = _mm_rsqrt_ps (a_elements);	

	auto start = system_clock::now();
	float res_seriell = reciproc_seriell(a[3],start_elements[3],1);
	auto end = system_clock::now();
	const double elapsed_seconds_serial = duration<double>(end - start).count();	

	start = system_clock::now();
	float res_seriell_sqrt = reciproc_sqrt_seriell(a[3],start_elements_sqrt[3],1);
	end = system_clock::now();
	const double elapsed_seconds_sqrt_serial = duration<double>(end - start).count();		

	start = system_clock::now();
	__m128 res = reciproc_sse(a_elements,start_elements);
	end = system_clock::now();
	const double elapsed_seconds_sse = duration<double>(end - start).count();

	start = system_clock::now();
	__m128 res_sqrt = reciproc_sqrt_sse(a_elements,start_elements_sqrt);
	end = system_clock::now();
	const double elapsed_seconds_sse_sqrt = duration<double>(end - start).count();

	std::cout << "Vektorisiertes 1/x:  " << res[0] << std::endl;
	std::cout << "Vektorisiertes 1/x:  " << res[1] << std::endl;
	std::cout << "Vektorisiertes 1/x:  " << res[2] << std::endl;
	std::cout << "Vektorisiertes 1/x:  " << res[3] << std::endl;

	std::cout << "Serielles 1/x:  " << res_seriell << std::endl;
	
	std::cout << "time taken serial program 1/x : "<< elapsed_seconds_serial << std::endl;
	std::cout << "time taken vectorized program: "<< elapsed_seconds_sse << std::endl;

	std::cout << "Serielles 1/sqrt(x):  " << res_seriell_sqrt << std::endl;	

	std::cout << "Vektorisiertes 1/sqrt(x):  " << res_sqrt[0] << std::endl;
	std::cout << "Vektorisiertes 1/sqrt(x):  " << res_sqrt[1] << std::endl;
	std::cout << "Vektorisiertes 1/sqrt(x):  " << res_sqrt[2] << std::endl;
	std::cout << "Vektorisiertes 1/sqrt(x):  " << res_sqrt[3] << std::endl;

	std::cout << "time taken serial program 1/sqrt(x) : "<< elapsed_seconds_sqrt_serial << std::endl;
	std::cout << "time taken vectorized program 1/sqrt(x): "<< elapsed_seconds_sse_sqrt << std::endl;

	free(a);
	free(start_val);
}

// mm_mul_ps(a_elements,b_elements);
//_mm_add_ps(res_elements , ab_elements);
//__m128 _mm_sub_ps (__m128 a, __m128 b)
//__m128 _mm_rcp_ps (__m128 a)
