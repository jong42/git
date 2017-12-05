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
	//test git
	
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
