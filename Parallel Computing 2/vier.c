#include <stdio.h>
#include <omp.h>

int main (void) {
	
	int i = 10;
	
	#pragma omp parallel firstprivate(i)
		{
			i = 1000 + omp_get_thread_num();
			printf ("i = %d\n", i);
		}
	
		return 0;
	
}