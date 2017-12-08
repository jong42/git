
#include <mpi.h>
#include <stdio.h>

int main(int argc, char *argv[]){
	
	int ret = MPI_Init(&argc,&argv);
	int rank, num;
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &num);
	
	int sum_total;	
	float x = ((double) rand() / (RAND_MAX));
	float y = ((double) rand() / (RAND_MAX));
	int sum = 0;

	if(x*x + y*y < 1){sum+=1;};
	
	MPI_Reduce(&sum,&sum_total,1,MPI_FLOAT,MPI_SUM,rank, MPI_COMM_WORLD);
	
	std::cout << sum_total << std::endl;	
	MPI_Finalize();
	

}
