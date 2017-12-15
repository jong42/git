#include <mpi.h>
#include <stdio.h>
#include <vector>

int main(int argc, char *argv[]){
	int ret = MPI_Init(&argc,&argv);
	int rank, num;
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &num);

	std::vector <int> a(24);
	std::vector <int> b(24);
	std::vector <int> c(24);

	// Initialize vectors
	for (int i=0; i<a.size();i++){
		a[i] = i + (rand() % 10);
		b[i] = b.size()-i + (rand() % 10);	
	}

	int ops_per_process = a.size()/num;
	std::vector <int> c_little(ops_per_process);
	
	// Calculate partial sum on each process
	for (int i=0;i<ops_per_process;i++){
		c_little[i] = a[rank*ops_per_process+i] + b[rank*ops_per_process+i];
	}

	MPI_Gather(&c_little[0],ops_per_process,MPI_INT,&c[0],ops_per_process,MPI_INT,0,MPI_COMM_WORLD);

	if(rank==0){
		for (int i=0;i<c.size();i++){
			std::cout << a[i] << std::endl;
			std::cout << b[i] << std::endl;				
			std::cout << c[i] << std::endl;	
		}
	}	

	//std::cout << num << std::endl;

	MPI_Finalize();
}
