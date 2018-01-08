#include <iostream>
#include <vector>
#include <fstream>
#include <cmath>
#include <xmmintrin.h>
#include "pmmintrin.h"
#include <chrono>

using std::chrono::system_clock;
using std::chrono::duration;

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
			
		}
		// set start vector for next iteration
		std::swap(x,u);
	}
	return u;
}


float * jacobi_upwind_sse(int n, float v, int iter){
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
	float * x;
	float * u;
	float * u_leftleft;
	float * u_left;
	posix_memalign((void**)&x, 16, sizeof(float)*((n+4)*(n+4)));
	posix_memalign((void**)&u, 16, sizeof(float)*((n+4)*(n+4)));
	posix_memalign((void**)&u_leftleft, 16, sizeof(float)*4);
	posix_memalign((void**)&u_left, 16, sizeof(float)*4);

	__m128 x_vec;
	__m128 u_vec_upup;
	__m128 u_vec_up;
	__m128 u_vec_leftleft;
	__m128 u_vec_left;
	__m128 upup_vec;
	__m128 up_vec;
	__m128 leftleft_vec;
	__m128 left_vec;

	__m128 a_upup_vec = _mm_load_ps1(&a_upup);
	__m128 a_up_vec = _mm_load_ps1(&a_up);
	__m128 a_left_vec = _mm_load_ps1(&a_left);
	__m128 a_leftleft_vec = _mm_load_ps1(&a_leftleft);
	__m128 a_diag_vec = _mm_load_ps1(&a_diag);
	__m128 ones_sse = _mm_set_ps1(1.0);

	// Begin iterations
	for (int w=0;w<iter;w++){
		for (int i=2;i<n+4;i++){
			for (int j=4;j<n+4;j=j+4){
				
				// load old matrix values needed for computing the new vector
				u_vec_upup = _mm_load_ps(&u[(i-2)*(n+4)+j]);	
				u_vec_up = _mm_load_ps(&u[(i-1)*(n+4)+j]);
				
				u_leftleft[0] = u[i*(n+4)+j-2];
				u_leftleft[1] = u[i*(n+4)+j-2+1];
				u_leftleft[2] = u[i*(n+4)+j-2+2];
				u_leftleft[3] = u[i*(n+4)+j-2+3];

				u_left[0] = u[i*(n+2)+j-1];
				u_left[1] = u[i*(n+2)+j-1+1];
				u_left[2] = u[i*(n+2)+j-1+2];
				u_left[3] = u[i*(n+2)+j-1+3];

				u_vec_leftleft = _mm_load_ps(&u_leftleft[0]);
				u_vec_left = _mm_load_ps(&u_left[0]);


				// Calculate new vector of values
				upup_vec = _mm_mul_ps(a_upup_vec,u_vec_upup);
				up_vec = _mm_mul_ps(a_up_vec,u_vec_up);
				leftleft_vec = _mm_mul_ps(a_leftleft_vec,u_vec_leftleft);
				left_vec = _mm_mul_ps(a_left_vec,u_vec_left); 
				x_vec = _mm_add_ps(_mm_add_ps(up_vec,upup_vec), _mm_add_ps(left_vec,leftleft_vec));
				x_vec = _mm_sub_ps (ones_sse,x_vec);
				x_vec = _mm_div_ps(x_vec,a_diag_vec);

				// Write new values back to x
				_mm_store_ps(&x[i*(n+4)+j],x_vec);

			}
			
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
	auto start = system_clock::now();
	float * res_sse = jacobi_upwind_sse(n,50,2000);
	auto end = system_clock::now();
	const double elapsed_seconds_sse = duration<double>(end - start).count();
	start = system_clock::now();
	std::vector<float> res_serial = jacobi_upwind(n,50,2000);
	end = system_clock::now();
	const double elapsed_seconds_serial = duration<double>(end - start).count();
	std::string name_sse = "A9_result_sse.dat";
	std::string name_serial = "A9_result_serial.dat";
	std::cout << "Time taken serial program: " << elapsed_seconds_serial << std::endl;
	std::cout << "Time taken with SSE: " << elapsed_seconds_sse << std::endl;
	fs.open(name_sse);
	for(int i=2; i<(n+4); i++){
		if (i != 0){
			fs << std::endl;
		}
		for (int j=2; j<(n+4); j++){
			fs << i*h << " " << j*h << " " << res_sse[i*(n+4)+j] << std::endl;
		}	
	}
	
	fs.close();
	fs.open(name_serial);
	for(int i=2; i<(n+4); i++){
		if (i != 0){
			fs << std::endl;
		}
		for (int j=2; j<(n+4); j++){
			fs << i*h << " " << j*h << " " << res_serial[i*(n+4)+j] << std::endl;
		}	
	}
	
	fs.close();
}
