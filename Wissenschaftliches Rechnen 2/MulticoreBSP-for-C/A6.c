# include <stdio.h>
# include "include/mcbsp.h"
int n;

void spmd_start() {
	bsp_begin(n);
	printf("Hello from process %d of %d", bsp_pid(), bsp_nprocs());
	bsp_end();
}

void main (int argc, char **argv) {
	bsp_init(spmd_start, argc, argv);
	printf("Number of processes? ");
	scanf("%d", &n);
	spmd_start();
}
