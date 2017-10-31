#include <stdio.h>
#include <omp.h>

int main (void) {
	
	int i;
	
	#pragma omp parallel 
	#pragma omp for schedule (dynamic,10)
		for (i=0; i <= 100; i++) {
			printf("i=%d",i);
		}

	
}