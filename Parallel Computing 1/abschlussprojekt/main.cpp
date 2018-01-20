#include <mpi.h>
#include<vector>
#include<ctime>
#include<cstdlib>
#include<iostream>


void waermeleitung_iteration(float* input, float* output, int size_x, int size_y, 
	int edge_size_up, int edge_size_down, int edge_size_left, int edge_size_right){

	for (int i=edge_size_up;i<size_y-edge_size_down;++i){
		for (int j=edge_size_left;j<size_x-edge_size_right;++j){
			*(output+(i*size_x+j)) = (*(input+(i*size_x+j-1)) + *(input+(i*size_x+j+1)) + 
				*(input+((i+1)*size_x+j)) + *(input+((i-1)*size_x+j)) )/4;
		}	
	}
}

int main(int argc, char *argv[]){

int ret = MPI_Init(&argc,&argv);
int rank, num;
MPI_Comm_rank(MPI_COMM_WORLD, &rank);
MPI_Comm_size(MPI_COMM_WORLD, &num);

int n = 10;
int iter = 1;
float edge_val = 100.0;
std::vector<float>img_input(n*n);
std::vector<float>img_output(n*n,edge_val);
std::srand(std::time(nullptr));
int lines_per_process = n/num;
int cells_per_process = (n*n)/num;

// Initialisiere Ausgangsbild
for (int i=0; i<n; ++i){
	for (int j=0; j<n; ++j){
		if (i==0 || j==0 || i==n-1 || j==n-1){
			img_input[i*n+j] = edge_val;
		}else{
			//img_input[i*n+j] = std::rand()/10000000;
			img_input[i*n+j] = 0.0;
		}
	}
}


// Gebe Startwerte aus

if (rank==0){
	for (int i=0; i<n; ++i){
		std::cout << std::endl;
		for (int j=0; j<n; ++j){
			std::cout << img_input[i*n+j] << " ";
		}
	}
	std::cout << std::endl;
}


// Führe Wärmeleitungs-Iterationen aus. Behandle dabei ersten und letzten Prozess unterschiedlich
for(int i=0;i<iter;++i){
	if (rank==0){
		waermeleitung_iteration(&img_input[rank*cells_per_process],
		&img_output[rank*cells_per_process],n,lines_per_process,1,0,1,1);
	} else if (rank==num-1){
		waermeleitung_iteration(&img_input[rank*cells_per_process],
		&img_output[rank*cells_per_process],n,lines_per_process,0,1,1,1);
	} else {
		waermeleitung_iteration(&img_input[rank*cells_per_process],
		&img_output[rank*cells_per_process],n,lines_per_process,0,0,1,1);
	}
	
	// Schicke Teilergebnisse an Root-Prozess
	MPI_Gather(&img_output[rank*cells_per_process],
		cells_per_process,
		MPI_FLOAT,
		&img_output[rank*cells_per_process],
		cells_per_process,
		MPI_FLOAT,
		0,
		MPI_COMM_WORLD);

	img_input.swap(img_output);

	// Schicke Gesamtgebniss zurück an alle Teilprozesse
	MPI_Scatter(&img_input[0],
		n*n,
		MPI_FLOAT,
		&img_input[0],
		n*n,
		MPI_FLOAT,
		0,
		MPI_COMM_WORLD);

}


// Gebe Werte aus
if (rank==0){
	for (int i=0; i<n; ++i){
		std::cout << std::endl;
		for (int j=0; j<n; ++j){
			std::cout << img_input[i*n+j] << " ";
		}
	}
	std::cout << std::endl;
}

MPI_Finalize();


}
