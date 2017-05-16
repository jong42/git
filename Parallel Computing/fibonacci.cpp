#include <iostream>

using namespace std;

int fib(int n) {
	int ret;
	// catch error
	if (n < 0)
		cout << "Error: fibonacci argument lesser than 0";
	// set te first values fib(0) = 0, fib(1),fib(2) = 1
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
	// set te first values fib(0) = 0, fib(1),fib(2) = 1
	if (n == 0)
		ret = 0;
	if (n == 1)
		ret = 1;
	if (n == 2)
		ret = 1;
	// recursive part
		
	return ret;
}


int main()
{
    cout << fib(8);
    //fib_par(0);
    return 0;
}
