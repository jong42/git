#include <vector>
#include<ctime>
#include<cstdlib>
#include<iostream>

int main() {

	std::srand(std::time(nullptr));
	int n = 5;
	std::vector<float> a(n*n);
	std::vector<float> b(n*n);	
	std::vector<float> c(n*n);


	//Initialisiere Matrizen

	for (int i=0;i<n*n;++i){
		a[i] = std::rand()/10000000;
		b[i] = std::rand()/10000000;
		c[i] = std::rand()/10000000;
		}

	// Gebe Start-Matrizen aus

	std::cout << "Matrix A:";
	for (int i=0;i<n;++i){
		std::cout << std::endl;
		for (int j=0;j<n;++j){
			std::cout << a[i*n+j] << " ";
		}
	}
	std::cout << std::endl;
	std::cout << std::endl;

	std::cout << "Matrix B:";
	for (int i=0;i<n;++i){
		std::cout << std::endl;
		for (int j=0;j<n;++j){
			std::cout << b[i*n+j] << " ";
		}
	}
	std::cout << std::endl;
	std::cout << std::endl;

	std::cout << "Matrix C:";
	for (int i=0;i<n;++i){
		std::cout << std::endl;
		for (int j=0;j<n;++j){
			std::cout << c[i*n+j] << " ";
		}
	}
	std::cout << std::endl;
	std::cout << std::endl;

	// Berechne Matrix-Matrix-Produkt
	for (int i=0;i<n;++i){
		for (int j=0;j<n;++j){
			for (int k=0;k<n;++k){
				c[i*n+j] += a[i*n+k]*b[k*n+j];
			}
		}
	}

	// Gebe Ergebnis-Matrix aus
	std::cout << "Ergebnis-Matrix C:";
	for (int i=0;i<n;++i){
		std::cout << std::endl;
		for (int j=0;j<n;++j){
			std::cout << c[i*n+j] << " ";
		}
	}
	std::cout << std::endl;		

}
