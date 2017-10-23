#include <stdio.h>

int praefixsum(int x) {
	int sum = 0;
	for (int i = x;i>0; i-=1) {
		sum = sum + i;
		}	
	return sum;
}

int main(){
	printf("%i",praefixsum(2));
	return 0;
}

