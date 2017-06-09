__device__ volatile int X = 1, Y = 2;   // volatile Variable kann außerhalb des Programms 
										// verändert werden
__device__ void schreibe() {
	X = 10;
	Y = 20;
}
__device__ void lese() {
	int A = X;
	int B = Y;
}


// A kann die Werte 1 oder 10 annehmen, B die Werte 2 oder 20
