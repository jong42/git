#include <iostream>
#include <vector>
#include <stdlib.h>
#include <xmmintrin.h>
#include "pmmintrin.h"
#include <chrono>

using std::chrono::system_clock;
using std::chrono::duration;


float scalar_seriell (float* a, float* b, int n){
	float c = 0.0;

	for (int i=0; i<n; i++) {
		c += a[i] * b[i];
	}

	return c;

}

float scalar_vectorized (float* a, float* b, int n){

	float c = 0.0;
	
	__m128 res_elements = _mm_set_ps1 (0.0f);

	for (int i=0;i<n;i=i+4) {
		__m128 a_elements = _mm_load_ps(a+i);
		__m128 b_elements = _mm_load_ps(b+i);

		__m128 ab_elements = _mm_mul_ps(a_elements,b_elements);
		res_elements = _mm_add_ps(res_elements , ab_elements);
	}


	__m128 sum = _mm_hadd_ps( res_elements,res_elements);
	sum = _mm_hadd_ps( sum,sum);
	
	
	float res;
	_mm_store_ss(&res , sum);
	
	return res;

}



int main(int argc, char* argv[]) {
	
	if (argc != 3) {
        // 
        std::cerr << " Wrong number of arguments. requires first integer as array size\
			 and second integer as number of iterations" << std::endl;
        return 1;
    }	

	int n = atoi (argv[1]);
	int k = atoi (argv[2]);
	float * a;
	float * b;
	
	posix_memalign((void**)&a, 128, sizeof(float)*n);
	posix_memalign((void**)&b, 128, sizeof(float)*n);

	for (int i=0;i<n;i++) {
		a[i] = i+1;
		b[i] = n-i;
	}

	float res_seriell;
	float res_vectorized;

	auto start = system_clock::now();
	for (int i=0;i<k;i++) {
		res_seriell = scalar_seriell(a,b,n); 	
	}
	auto end = system_clock::now();
	const double elapsed_seconds_serial = duration<double>(end - start).count();
		
	start = system_clock::now();
	for (int i=0;i<k;i++) {
		res_vectorized = scalar_vectorized(a,b,n);
	} 
	end = system_clock::now();
	const double elapsed_seconds_vec = duration<double>(end - start).count();

	free (a);
	free (b);

	std::cout << "Serielles Skalarprodukt: " << res_seriell << std::endl;
	std::cout << "Vektorisiertes Skalarprodukt: " << res_vectorized << std::endl;
	std::cout << "time taken serial program: "<< elapsed_seconds_serial << std::endl;
	std::cout << "time taken vectorized program: "<< elapsed_seconds_vec << std::endl;
}
