
#include <mpi.h>
#include <stdio.h>


int main(int argc, char *argv[]){

	int ret = MPI_Init(&argc,&argv);
	int rank, num;
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &num);

	int n = 10;
	int a[n];
	int b[n];
	int c;

	for (int i=0;i<n;i++){
		a[i] = i+1;
		b[i] = n-i;
	}
	
	int* a_little = new int[n/num];
	int* b_little = new int[n/num];

	MPI_Scatter(&a,n/num,MPI_INT,a_little,n/num,MPI_INT,0,MPI_COMM_WORLD);
	MPI_Scatter(&b,n/num,MPI_INT,b_little,n/num,MPI_INT,0,MPI_COMM_WORLD);

	int c_little = 0;

	for (int i=0;i<(n/num);i++){
		c_little += a_little[i] * b_little[i];
	}
	
	MPI_Reduce(&c_little,&c,1,MPI_INT,MPI_SUM,rank, MPI_COMM_WORLD);	
	MPI_Finalize();
	
std::cout << c << std::endl;
}
