#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <sys/time.h>


void fillArray(double* a, int n, int k)
{
   for (int i=0;i<n;i++)
   {
      a[i]=1.0/(double)(i+1)*(double)(k+1);
   }
}

int main(int argc, char **argv)
{
    int size=10000;
    if (argc>1)
    {
       size=atoi(argv[1]);
    }
    double **array;
    int nthreads;
    //The following block should be executed in parallel, use barriers where necessary
    {
	#pragma omp parallel 
	{
       timeval t_start,t_end;
       nthreads=omp_get_num_threads();
       int i=omp_get_thread_num();
    
    #pragma omp master 
    {
       // The top level of the array should be allocated by the master thread 
       printf("Started %i threads\n",nthreads);
       array=(double**)malloc(nthreads*sizeof(double*));
     }  
       
	#pragma omp barrier 
       //Each thread allocates the internal memory
       array[i]=(double*)malloc(size*sizeof(double));
       
    #pragma omp barrier   
       //Each thread fills its own array (10 iterations for better timing)
       gettimeofday(&t_start,0);
       for (int j=0;j<10;j++)
          fillArray(array[i],size,i);
       gettimeofday(&t_end,0);
       double time=((t_end.tv_usec+t_end.tv_sec*1e6)-(t_start.tv_usec +t_start.tv_sec*1e6))/1e6/10;
       printf("Fill Array: %i: %f\n",i,time);
       
     #pragma omp barrier   
       //Each thread i should do the following summation of the array of thread i+1 (again 10 iterations for better timing)
       gettimeofday(&t_start,0);
       double sum;
       for (int j=0;j<10;j++)
       {
          sum=0.0;
          for (int k=0;k<size;k++)
          {
             sum+=array[(i+1)%nthreads][k];
          }
       }
       gettimeofday(&t_end,0);
       time=((t_end.tv_usec+t_end.tv_sec*1e6)-(t_start.tv_usec+t_start.tv_sec*1e6))/1e6/10;
       printf("%i: Sum %f! Time: %f [accessed array %i]\n",i,sum,time,(i+1)%nthreads);
	#pragma omp barrier 
       //Each thread frees its internal array
       free(array[i]);
	#pragma omp barrier 
	#pragma omp master
	{
       //now free the toplevel array
       free(array);
    }
    }
}

    return 0;
}
