#include <iostream>
#include <sstream>
#include <cmath>  
#include <xmmintrin.h>
#include "pmmintrin.h"
#include <chrono>  

using std::chrono::system_clock;
using std::chrono::duration;

float naive_exp(float x, int number_of_terms){
	float x_abs = abs(x);
	float res = 1+x_abs/number_of_terms;
	for (int i=1; i<number_of_terms; i++){
		res = 1 + res * (x_abs/(number_of_terms-i));
	}

	if (x >= 0.0){
		std::cout << res << std::endl;
		return res;
	} else if (x < 0){
		std::cout << 1/res << std::endl;
		return 1/res;
	}
}

__m128 sse_exp_a(__m128 x, int number_of_terms){
	// Make all elements positive
	__m128 x_abs = _mm_mul_ps (x,x);
	x_abs = _mm_sqrt_ps(x_abs);
	// Set up auxilliary variables
	__m128 number_of_terms_sse = _mm_set_ps1 ((float)number_of_terms);
	__m128 zeros_sse = _mm_set_ps1 (0.0);
	__m128 ones_sse = _mm_set_ps1 (1.0);
	__m128 iter;
	__m128 res_temp;
	__m128 res = _mm_add_ps (ones_sse,_mm_div_ps(x,number_of_terms_sse));
	
	// Calculate result of power series	
	for (int i=1; i<number_of_terms; i++){
		iter = _mm_set_ps1((float) i);
		res_temp = _mm_sub_ps (number_of_terms_sse,iter);		
		res_temp = _mm_div_ps (x,res_temp);
		res_temp = _mm_mul_ps (res_temp,res);
		res = _mm_add_ps (res_temp,ones_sse);
	}

	//// set reciproc results for negative inputs
	// Set alpha as 0 for positive, 1 for negative values of x
	__m128 alpha = _mm_min_ps(zeros_sse,_mm_div_ps (x,x));
	// Calculate reciproc vals of results
	__m128 recipr_res = _mm_div_ps (ones_sse,_mm_mul_ps (x,x));
	// Calculate result_vectors for positive and negative inputs
	__m128 positive_res = _mm_mul_ps (_mm_sub_ps(ones_sse,alpha),res);
	__m128 negative_res = _mm_mul_ps (alpha,recipr_res);
	res = _mm_add_ps(positive_res,negative_res);
	
	return res;
}

__m128 sse_exp_b(__m128 x){
	// Make number of terms dependent from argument size
	__m128 number_of_terms_sse = _mm_hadd_ps(x,x);
	number_of_terms_sse = _mm_hadd_ps(number_of_terms_sse,number_of_terms_sse);
	int number_of_terms = (int) number_of_terms_sse[0];
	// Make all elements positive
	__m128 x_abs = _mm_mul_ps (x,x);
	x_abs = _mm_sqrt_ps(x_abs);
	// Set up auxilliary variables
	__m128 zeros_sse = _mm_set_ps1 (0.0);
	__m128 ones_sse = _mm_set_ps1 (1.0);
	__m128 iter;
	__m128 res_temp;
	__m128 res = _mm_add_ps (ones_sse,_mm_div_ps(x,number_of_terms_sse));
	
	// Calculate result of power series	
	for (int i=1; i<number_of_terms; i++){
		iter = _mm_set_ps1((float) i);
		res_temp = _mm_sub_ps (number_of_terms_sse,iter);		
		res_temp = _mm_div_ps (x,res_temp);
		res_temp = _mm_mul_ps (res_temp,res);
		res = _mm_add_ps (res_temp,ones_sse);
	}

	//// set reciproc results for negative inputs
	// Set alpha as 0 for positive, 1 for negative values of x
	__m128 alpha = _mm_min_ps(zeros_sse,_mm_div_ps (x,x));
	// Calculate reciproc vals of results
	__m128 recipr_res = _mm_div_ps (ones_sse,_mm_mul_ps (x,x));
	// Calculate result_vectors for positive and negative inputs
	__m128 positive_res = _mm_mul_ps (_mm_sub_ps(ones_sse,alpha),res);
	__m128 negative_res = _mm_mul_ps (alpha,recipr_res);
	res = _mm_add_ps(positive_res,negative_res);
	
	return res;
}


int main(int argc, char** argv){

  	if (6 != argc) {
  	  std::cerr << "usage: " << argv[0] << 
		" <float x1> <float x2> <float x3> <float x4> <int number_of_terms>"
  	            << std::endl;
  	  return -1;
  	}

  	float * a;
	posix_memalign((void**)&a, 16, sizeof(float)*4);

  	if (!(std::istringstream(argv[1]) >> a[0])) {
    	std::cerr << "argument is not a valid float";
    	return -1;
  	}

  	if (!(std::istringstream(argv[2]) >> a[1])) {
	   	std::cerr << "argument is not a valid float";
    	return -1;
  	}
	
  	if (!(std::istringstream(argv[3]) >> a[2])) {
    	std::cerr << "argument is not a valid float";
    	return -1;
  	}

  	if (!(std::istringstream(argv[4]) >> a[3])) {
    	std::cerr << "argument is not a valid float";
    	return -1;
  	}	

  	int number_of_terms;

  	if (!(std::istringstream(argv[5]) >> number_of_terms)) {
    	std::cerr << "argument is not a valid integer";
    	return -1;
  	}

	__m128 a_elements = _mm_load_ps(a);
	auto start = system_clock::now();
	__m128 res_sse_a = sse_exp_a(a_elements, number_of_terms);
	auto end = system_clock::now();
	const double elapsed_seconds_res_sse_a = duration<double>(end - start).count();

	start = system_clock::now();
	__m128 res_sse_b = sse_exp_b(a_elements);
	end = system_clock::now();
	const double elapsed_seconds_res_sse_b = duration<double>(end - start).count();

	float res_scalar[4];
	start = system_clock::now();
	res_scalar[0] = exp(a[0]);
	res_scalar[1] = exp(a[1]);
	res_scalar[2] = exp(a[2]);
	res_scalar[3] = exp(a[3]);
	end = system_clock::now();
	const double elapsed_seconds_res_scalar = duration<double>(end - start).count();

	float precision_a[4];
	float precision_b[4];

	for (int i=0;i<4;i++){
		precision_a[i] = res_sse_a[i] - res_scalar[i];
		precision_b[i] = res_sse_b[i] - res_scalar[i];
	}

	std::cout << "Vektorisiertes Ergebnis 1: "<< res_sse_b [0] << std::endl;
	std::cout << "Vektorisiertes Ergebnis 2: "<< res_sse_b [1] << std::endl;
	std::cout << "Vektorisiertes Ergebnis 3: "<< res_sse_b [2] << std::endl;
	std::cout << "Vektorisiertes Ergebnis 4: "<< res_sse_b [3] << std::endl;
	
	std::cout << std::endl;

	std::cout << "Skalares Ergebnis 1: "<< exp(a[0]) << std::endl;
	std::cout << "Skalares Ergebnis 2: "<< exp(a[1]) << std::endl;
	std::cout << "Skalares Ergebnis 3: "<< exp(a[2]) << std::endl;
	std::cout << "Skalares Ergebnis 4: "<< exp(a[3]) << std::endl;

	std::cout << std::endl;

	std::cout << "Time taken vectorized approach a: " << elapsed_seconds_res_sse_a << std::endl;
	std::cout << "Time taken vectorized approach b: " << elapsed_seconds_res_sse_b << std::endl;
	std::cout << "Time taken scalar approach: " << elapsed_seconds_res_scalar << std::endl;

	std::cout << std::endl;
	
	std::cout << "Difference to scalar res a 1: " << precision_a[0] << std::endl;
	std::cout << "Difference to scalar res a 2: " << precision_a[1] << std::endl;
	std::cout << "Difference to scalar res a 3: " << precision_a[2] << std::endl;
	std::cout << "Difference to scalar res a 4: " << precision_a[3] << std::endl;
	std::cout << "Difference to scalar res b 1: " << precision_b[0] << std::endl;
	std::cout << "Difference to scalar res b 2: " << precision_b[1] << std::endl;
	std::cout << "Difference to scalar res b 3: " << precision_b[2] << std::endl;
	std::cout << "Difference to scalar res b 4: " << precision_b[3] << std::endl;
}
