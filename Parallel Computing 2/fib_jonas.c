//g++ --openmp -o fib fib.c
// ./fib [Number of threads]
#include <iostream>
#include <omp.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

using namespace std;

double cpu_time(void){

  double value;
  value = (double) clock () / (double) CLOCKS_PER_SEC;
  return value;
}



int fib(int n) {
	int ret;
	// catch error
	if (n < 0)
		cout << "Error: fibonacci argument lesser than 0";
	// set the first values fib(0) = 0, fib(1),fib(2) = 1
	if (n == 0)
		ret = 0;
	if (n == 1)
		ret = 1;
	if (n == 2)
		ret = 1;
	// recursive part
	if (n > 2)
		ret = fib(n-1) + fib(n-2);
	
	return ret;
}


int fib_par (int n) {
	//std::cout << "n: "<< (double)(n)<<std::endl;
	int ret;
	// catch error
	if (n < 0)
		cout << "Error: fibonacci argument lesser than 0";
	// set the first values fib(0) = 0, fib(1),fib(2) = 1
	if (n == 0)
		ret = 0;
	if (n == 1)
		ret = 1;
	if (n == 2)
		ret = 1;
	if (n > 2)
	{
		// initialize variables for recursive part
		int tid;
		// disable dynamic thread numbers
		omp_set_dynamic(0);
		// recursive part
	# pragma omp parallel private(tid) shared(ret) num_threads(2)
		{
			tid = omp_get_thread_num();
			ret = ret + fib_par((n-2+tid));

			//std::cout << "Thread_ID: "<< (double)(tid) << " ";
			//std::cout << "n: "<< (double)(n)<<std::endl;
			
		}
	}
	std::cout << "ret: "<< (double)(ret)<<std::endl;	
	return ret;
}




int main()
{

    double ctime2_, ctime1_,ctime2, ctime1;
    ctime1_ = cpu_time();
    ctime1 = omp_get_wtime();
    int erg;
    int ret;
    ret = 0;
    erg = fib_par(5);    
    ctime2 = omp_get_wtime();
    ctime2_ = cpu_time();
    std::cout << "Fib:"<< erg <<std::endl;    
    std::cout << "Walltime:"<< (double)(ctime2 - ctime1)<<std::endl;    
    std::cout << "CPU-Time:"<< (double)(ctime2_ - ctime1_)<<std::endl;
    return 0;
}
