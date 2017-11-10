#include <iostream>
using namespace std;
int main (){
	int a = 3;
	int b = a;
	b=5;
	int* c = &a;
	*c = 6;
	int& d = a;
	d=7;
	cout << a << " " << b << " " << c  << " " << d << std::endl;
	return 0;
}
