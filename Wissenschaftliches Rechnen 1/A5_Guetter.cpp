#include <iostream>
#include <stdio.h>
#include <vector>
#include <cmath>

std::vector<float> jacobi(int n, float v, int iter){
	// Initialize variables
	float h =1/(n+1);
	std::vector<float> b(n*n);
	for(int i=0; i<n*n; i++){
		b[i] = 1;
	}
	float v_x = v/sqrt(5);
	float v_y = v/(2*sqrt(5));
	float a_diag = 4/pow(h,2) - v_x/h - v_y/h;
	float a_lr = -1/pow(h,2) + v_x/h;
	float a_ud = -1/pow(h,2) + v_y/h;
	std::vector<float> u(n*n);
	std::vector<float> x(n*n);
	// Initialize start vector u
	for(int i=0; i<n; i++){
		u[i] = 1;
	}
	// Begin iterations
	for (int w=0;w<iter;w++){
		std::cout << "hello there" << std::endl;
		for (int i=n;i<(n*(n-1));i++){
			x[i] = b[i]- (a_ud*u[i-n]+a_lr*u[i-1]+a_lr*u[i+1]+a_ud*u[i+n])/a_diag;
		}
		// set start vector for next iteration
		u = x;
	}
	return u;
}

int main() {
	
	jacobi(10,10,10);
}