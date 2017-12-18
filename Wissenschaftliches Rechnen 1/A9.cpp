#include <iostream>
#include <vector>
#include <fstream>
#include <cmath>
#include <xmmintrin.h>
#include "pmmintrin.h"

std::vector<float> gs_upwind(int n, float v, int iter){
	// Initialize variables
	float h =(float)1/(n+1);
	std::vector<float> b((n+2)*(n+2));
	for(int i=0; i<n*n; i++){
		b[i] = 1;
	}
	float v_x = v/sqrt(5);
	float v_y = 2*v/(sqrt(5));
	float a_diag = -2/(h*h) + v_x/h + v_y/h;
	float a_left = 2/(h*h) -v_x/(h);
	float a_leftleft = -1/(h*h);
	float a_up = 2/(h*h) - v_y/(h);
	float a_upup = -1/(h*h);
	std::vector<float> u((n+2)*(n+2),0.0);
	// Begin iterations
	for (int w=0;w<iter;w++){
		for (int i=1;i<n+2;i++){
			for (int j=1;j<n+2;j++){

				u[i*(n+2)+j] = (1-(a_upup*u[(i-2)*(n+2)+j]+a_up*u[(i-1)*(n+2)+j]+a_leftleft*u[i*(n+2)+j-2]+a_left*u[i*(n+2)+j-1]))/a_diag;
			}
			//std::cout << x[i] << std::endl;
		}
	}
	return u;
}


std::vector<float> jacobi_upwind(int n, float v, int iter){
	// Initialize variables
	float h =(float)1/(n+1);
	std::vector<float> b((n+2)*(n+2));
	for(int i=0; i<n*n; i++){
		b[i] = 1;
	}
	float v_x = v/sqrt(5);
	float v_y = 2*v/(sqrt(5));
	float a_diag = -2/(h*h) + v_x/h + v_y/h;
	float a_left = 2/(h*h) -v_x/(h);
	float a_leftleft = -1/(h*h);
	float a_up = 2/(h*h) - v_y/(h);
	float a_upup = -1/(h*h);
	std::vector<float> u((n+2)*(n+2),0.0);
	std::vector<float> x((n+2)*(n+2),0.0);
	// Begin iterations
	for (int w=0;w<iter;w++){
		for (int i=2;i<n+2;i++){
			for (int j=2;j<n+2;j++){

				x[i*(n+2)+j] = (1-(a_upup*u[(i-2)*(n+2)+j]+a_up*u[(i-1)*(n+2)+j]+a_leftleft*u[i*(n+2)+j-2]+a_left*u[i*(n+2)+j-1]))/a_diag;
			}
			//std::cout << x[i] << std::endl;
		}
		// set start vector for next iteration
		std::swap(x,u);
	}
	return u;
}

float * jacobi_upwind_sse (int n, float v, int iter){
	// Initialize variables
	__m128 ones_sse = _mm_set_ps1 (1.0);
	float h =(float)1/(n+1);
	//std::vector<float> b((n+2)*(n+2));
	//for(int i=0; i<n*n; i++){
	//	b[i] = 1;
	//}
	float v_x = v/sqrt(5);
	__m128 v_x_vec = _mm_set_ps1(v_x);
	float v_y = 2*v/(sqrt(5));
	__m128 v_y_vec = _mm_set_ps1(v_y);
	float a_diag = -2/(h*h) + v_x/h + v_y/h;
	__m128 a_diag_vec = _mm_set_ps1(a_diag);
	float a_left = 2/(h*h) -v_x/(h);
	__m128 a_left_vec = _mm_set_ps1(a_left);
	float a_leftleft = -1/(h*h);
	__m128 a_leftleft_vec = _mm_set_ps1(a_leftleft);
	float a_up = 2/(h*h) - v_y/(h);
	__m128 a_up_vec = _mm_set_ps1(a_up);
	float a_upup = -1/(h*h);
	__m128 a_upup_vec = _mm_set_ps1(a_upup);
	//std::vector<float> u((n+2)*(n+2),0.0);
	//std::vector<float> x((n+2)*(n+2),0.0);
	float * x;
	float * u;
	posix_memalign((void**)&x, 16, sizeof(float)*((n+2)*(n+2)));
	posix_memalign((void**)&u, 16, sizeof(float)*((n+2)*(n+2)));
	int inner_loop_iterations;
	__m128 x_vec;
	__m128 u_vec_upup;
	__m128 u_vec_up;
	__m128 u_vec_leftleft;
	__m128 u_vec_left;
	__m128 upup_vec;
	__m128 up_vec;
	__m128 leftleft_vec;
	__m128 left_vec;
	// Begin iterations
	for (int w=0;w<iter;w++){
		inner_loop_iterations = 0;
		for (int i=2;i<n+2;i++){
			for (int j=2;j<n+2;j=j+4){
				// load old matrix values needed for computing the new vector
				u_vec_upup = _mm_load_ps(&u[(i-2)*(n+2)+j+inner_loop_iterations*4]);
				
				//std::cout << u[(i-2)*(n+2)+j+inner_loop_iterations*4] << std::endl;
				//std::cout << i << " " << j << std::endl;

				//u_vec_upup = _mm_set_ps(u[(i-2)*(n+2)+j+inner_loop_iterations*4],
				//		u[(i-2)*(n+2)+j+inner_loop_iterations*4 + 1],
				//		u[(i-2)*(n+2)+j+inner_loop_iterations*4 + 2],
				//		u[(i-2)*(n+2)+j+inner_loop_iterations*4 + 3]);

				u_vec_up = _mm_load_ps(&u[(i-1)*(n+2)+j+inner_loop_iterations*4]);
				u_vec_leftleft = _mm_load_ps(&u[i*(n+2)+j-2+inner_loop_iterations*4]);
				u_vec_left = _mm_load_ps(&u[i*(n+2)+j-1+inner_loop_iterations*4]);
				
				// Calculate new vector of values
				upup_vec = _mm_mul_ps(a_upup_vec,u_vec_upup);
				up_vec = _mm_mul_ps(a_up_vec,u_vec_up);
				leftleft_vec = _mm_mul_ps(a_leftleft_vec,u_vec_leftleft);
				left_vec = _mm_mul_ps(a_left_vec,u_vec_left); 
				x_vec = _mm_add_ps(_mm_add_ps(up_vec,upup_vec), _mm_add_ps(left_vec,leftleft_vec));
				x_vec = _mm_sub_ps (ones_sse,x_vec);
				x_vec = _mm_div_ps(x_vec,a_diag_vec);

				// Write new values back to x
				_mm_store_ps(&x[i*(n+2)+j+inner_loop_iterations*4],x_vec);
				
				inner_loop_iterations++;			
			}
			//std::cout << x[i] << std::endl;
		}
		// set start vector for next iteration
		std::swap(x,u);
	}
	return u;
}



int main(){
	std::ofstream fs;
	int n = 1024;	
	int v = 200;
	float h =(float)1/(n+1);
	float * res = jacobi_upwind_sse(n,50,2000);
	std::string name = "A9_result.dat";
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
