#include <stdio.h>

int main (void) {
	
	int n = 100000;
	
	int a[n];
	int b[n];
	
	int i = 0;
	int j = 0;
	
	for(;i<n;i++)
	{
		a[i] = i;
		b[i] = i;
	};
	
	int sum = 0;
	#pragma omp parallel for reduction( + : sum )
	for (j=0;j<n;j++)
		{
			sum = sum+a[j]*b[j];
		}
	
	printf("%d", sum);
	
	// Zeit messen in cl: time ./drei
	
}