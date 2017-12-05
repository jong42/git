#include <iostream>
#include <vector>


float scalar_seriell (std::vector<float> a, std::vector<float> b){
	float c = 0.0;

	for (int i=0; i<a.size(); i++) {
		c += a[i] * b[i];
	}

	return c;

}

float scalar_vectorized (std::vector<float> a, std::vector<float> b){
	float c = 0.0;

	// Unterteilung der Daten in Blöcke von je 4 Elementen
	// Datentyp: __m128 für float
	//Here is a simple code on how to use SSE in order to compute the square root of 4 float 
	//in a single operation using the _mm_sqrt_ps function.
	
	  float a[] __attribute__ ((aligned (16))) = { 41982.,  81.5091, 3.14, 42.666 };                                                                                                                                 
  	  __m128* ptr = (__m128*)a;                                                                                                                                                                                      
  	  __m128 t = _mm_sqrt_ps(*ptr);
	
	return c;

}



int main() {

	std::vector<float> a(12,5.0);
	std::vector<float> b(12,4.0);

	float res_seriell = scalar_seriell(a,b); 	
	float res_vectorized = scalar_vectorized(a,b); 
	std::cout << "Serielles Skalarprodukt: " << res_seriell << std::endl;
	std::cout << "Vektorisiertes Skalarprodukt: " << res_vectorized << std::endl;
}
