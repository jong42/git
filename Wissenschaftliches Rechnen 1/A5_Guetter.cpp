#include <iostream>
#include <iostream>
#include <vector>
#include <cmath>
#include <fstream>
#include <string>

std::vector<float> gs(int n, float v, int iter){
	// Initialize variables
	float h =(float)1/(n+1);
	std::vector<float> b((n+2)*(n+2));
	for(int i=0; i<n*n; i++){
		b[i] = 1;
	}
	float v_x = v/sqrt(5);
	float v_y = 2*v/(sqrt(5));
	float a_diag = 4/(h*h);
	float a_left = -1/(h*h) -v_x/(2*h);
	float a_right = -1/(h*h) +v_x/(2*h);
	float a_up = -1/(h*h) + v_y/(2*h);
	float a_down = -1/(h*h) - v_y/(2*h);
	std::vector<float> u((n+2)*(n+2),0.0);
	std::vector<float> x((n+2)*(n+2),0.0);
	// Begin iterations
	for (int w=0;w<iter;w++){
		for (int i=1;i<n+1;i++){
			for (int j=1;j<n+1;j++){

				u[i*(n+2)+j] = (b[i*(n+2)+j]-(a_down*u[(i-1)*(n+2)+j]+a_left*u[i*(n+2)+j-1]+a_right*u[i*(n+2)+j+1]+a_up*u[(i+1)*(n+2)+j]))/a_diag;
			}
			//std::cout << x[i] << std::endl;
		}
		// set start vector for next iteration

	}
	return u;
}


std::vector<float> jacobi(int n, float v, int iter){
	// Initialize variables
	float h =(float)1/(n+1);
	std::vector<float> b(n*n);
	for(int i=0; i<n*n; i++){
		b[i] = 1;
	}
	float v_x = v/sqrt(5);
	float v_y = 2*v/(sqrt(5));
	float a_diag = 4/(h*h);
	float a_left = -1/(h*h) -v_x/(2*h);
	float a_right = -1/(h*h) +v_x/(2*h);
	float a_up = -1/(h*h) + v_y/(2*h);
	float a_down = -1/(h*h) - v_y/(2*h);
	std::vector<float> u((n+2)*(n+2),0.0);
	std::vector<float> x((n+2)*(n+2),0.0);
	// Begin iterations
	for (int w=0;w<iter;w++){
		for (int i=1;i<n+1;i++){
			for (int j=1;j<n+1;j++){

				x[i*(n+2)+j] = (1-(a_down*u[(i-1)*(n+2)+j]+a_left*u[i*(n+2)+j-1]+a_right*u[i*(n+2)+j+1]+a_up*u[(i+1)*(n+2)+j]))/a_diag;
			}
			//std::cout << x[i] << std::endl;
		}
		// set start vector for next iteration
		u = x;
	}
	return u;
}

int main() {
	std::ofstream fs;
	int n = 25;	
	int v = 50;
	float h =(float)1/(n+1);
	std::vector<float> res = gs(n,50,200);
	
	std::string name = "25_50_result.dat";
	fs.open(name);
	for(int i=0; i<(n+2); i++){
		if (i != 0){
			fs << std::endl;
		}
		for (int j=0; j<(n+2); j++){
			fs << i*h << " " << j*h << " " << res[i*(n+2)+j] << std::endl;
		}	
	}
	
	fs.close();
}
