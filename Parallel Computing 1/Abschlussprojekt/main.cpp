#include<vector>
#include<ctime>
#include<cstdlib>
#include<iostream>


void waermeleitung_iteration(float* input, float* output, int size_x, int size_y){
	for (int i=1;i<size_y-1;++i){
		for (int j=1;j<size_x-1;++j){
			*(output+(i*size_x+j)) = (*(input+(i*size_x+j-1)) + *(input+(i*size_x+j+1)) + 
				*(input+((i+1)*size_x+j)) + *(input+((i+-1)*size_x+j)) )/4;
			//*(output+(i*size_x+j)) = *(input+(i*size_x+j));		
		}	
	}
}

int main(){

int n = 10;
int iter = 3;
float edge_val = 100.0;
std::vector<float>img_input(n*n);
std::vector<float>img_output(n*n,edge_val);
std::srand(std::time(nullptr));

// Initialisiere Ausgangsbild

for (int i=0; i<n; ++i){
	for (int j=0; j<n; ++j){
		if (i==0 || j==0 || i==n-1 || j==n-1){
			img_input[i*n+j] = edge_val;
		}else{
			img_input[i*n+j] = std::rand()/10000000;
		}
	}
}

// Gebe Startwerte aus

for (int i=0; i<n; ++i){
	std::cout << std::endl;
	for (int j=0; j<n; ++j){
		std::cout << img_input[i*n+j] << " ";
	}
}
std::cout << std::endl;


// Führe Wärmeleitungs-Iterationen aus
for(int i=0;i<iter;++i){
	waermeleitung_iteration(img_input.data(),img_output.data(),n,n);
	img_input.swap(img_output);
}
std::cout << std::endl;
	
}


// Gebe Werte aus

for (int i=0; i<n; ++i){
	std::cout << std::endl;
	for (int j=0; j<n; ++j){
		std::cout << img_input[i*n+j] << " ";
	}
}
std::cout << std::endl;


}
