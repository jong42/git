#include <mpi.h>
#include <stdio.h>
#include <math.h> 
 
int main(int argc, char *argv[]) {
    int ret = MPI_Init(&argc,&argv);
    if (ret != MPI_SUCCESS) {
        MPI_Abort(MPI_COMM_WORLD, ret);
    }
 	
	int x = 5;
    int num, rank;
    MPI_Comm_size(MPI_COMM_WORLD, &num);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
 
    printf("Hi %d of %d\n", rank, num);
 	
	if (rank!=0)
		{
			MPI_Send(&x,1,MPI_INT,0,0,MPI_COMM_WORLD);
		}
	
	if (rank=0)
		{
			for (int i=1;i<rank; i++){
				MPI_Recv(&x,1,MPI_INT,1,0,MPI_COMM_WORLD);
			}
		}

    MPI_Finalize();
    return 0;
}

// mpirun -n 4 a.out
//MPI_Send; MPI_Recv
// https://pastebin.com/fqu60jA7
