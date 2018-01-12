#define NUM_THREADS 8


void *thread_func(int position){
	for (int i=position;i<elements_per_thread+position;i++){
		for (int j=position;j<elements_per_thread+position;j++){
			x[i*(n+2)+j] += (1-(a_upup*u[(i-2)*(n+2)+j]+a_up*u[(i-1)*(n+2)+j]+a_leftleft*u[i*(n+2)+j-2]+a_left*u[i*(n+2)+j-1]))/a_diag;
		}
	}
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
	
	int elements_per_thread = (n+2)/NUM_THREADS;
	
	for (int w=0;w<iter;w++){
		// Starte Threads
		for(i=0; i<NUM_THREADS; i++){
			r = pthread_create(&tid, NULL, thread_func, elements_per_thread*i);
			thread_id[i] = tid;
		}	
	}
	
	// Begin iterations
	for (int w=0;w<iter;w++){
		for (int i=2;i<n+2;i++){
			for (int j=2;j<n+2;j++){

				x[i*(n+2)+j] = (1-(a_upup*u[(i-2)*(n+2)+j]+a_up*u[(i-1)*(n+2)+j]+a_leftleft*u[i*(n+2)+j-2]+a_left*u[i*(n+2)+j-1]))/a_diag;
			}
			//std::cout << x[i] << std::endl;
		}
		// set start vector for next iteration
		u = x;
	}
	std::swap(x,u);
}




int main() {
	std::ofstream fs;
	int n = 25;	
	//int n = 50;
	//int n = 100;		
	//int v = 50;
	int v = 200;
	float h =(float)1/(n+1);
	//std::vector<float> res = gs(n,50,200);
	//std::vector<float> res = jacobi(n,50,200);
	//std::vector<float> res = gs_upwind(n,50,200);
	std::vector<float> res = jacobi_upwind(n,50,200);
	
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