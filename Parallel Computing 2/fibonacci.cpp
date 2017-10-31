#include <iostream>
#include <omp.h>

using namespace std;

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
		ret = 0;
		int tid;
		// disable dynamic thread numbers
		omp_set_dynamic(0);
		// recursive part
	# pragma omp parallel private(tid) shared(ret) num_threads(2)
		{
			tid = omp_get_thread_num();
			ret = ret + fib(n-2+tid);
		}
	}
		
	return ret;
}




int main()
{
    //cout << fib(8);
    cout << fib_par(10);
    return 0;
}
