#include <stdio.h>

int main (void) {

int a[10];
int b[10];
int c[10];

int i = 0;
int j = 0;



for(;i<10;i++)
{
	a[i] = i;
	b[i] = i;
}

#pragma omp parallel for
	for (j=0;j<10;j++)
	{
		c[j] = a[j] + b[j];
	}
printf("%d", c[2]);
	
}