#include <iostream>
using namespace std;
int main() {
	int a[3] = {1,3,4};
	int *b = a;
	cout << *(b+2)<< std::endl;
	int d[3] = {5,6,7};
	for (int i=0;i < 3;i++) d[i] = a[i];
	return 0;
}
