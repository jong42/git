#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <iostream>
#include <numeric>
#include <chrono>  

using std::chrono::system_clock;
using std::chrono::duration;

#define NUM_THREADS 8

struct messagetype{
	double *a, *b;     // Zeiger auf 0. Element der (Teil-)Vektoren
	int n;             // Laenge der Teilvektoren
	double sum;        // Rueckgabevariable fur Teilskalarprodukt
};


double scalar_product(double * a,double * b, int length){
	double res = 0.0;	
	for (int i=0;i<length;i++){
		res+= *(a+i) * *(b+i);		
	}
	return res;
}

void *thread_func(void *param){
	messagetype message= *(messagetype*) param;
	(* (messagetype*) param).sum = scalar_product(message.a,message.b,message.n);
}


double threaded_scalar_product(double* a, double* b, int n){

	int i, r;
	pthread_t tid, thread_id[NUM_THREADS];
	messagetype message[NUM_THREADS];
	
	for(i=0; i<NUM_THREADS; i++){
		message[i].a = &a[i*(n/NUM_THREADS)];
		message[i].b = &b[i*(n/NUM_THREADS)];
		message[i].n = n/NUM_THREADS;
	}

	// Korrigiere Anzahl der Elemente für letzten Thread falls Threadanzahl nicht ganzzahlig teilbar durch Vektorgröße ist
	message[NUM_THREADS-1].n = n - (NUM_THREADS-1) * (n/NUM_THREADS);

	// Starte Threads
	//printf("Threads starten:\n");
	for(i=0; i<NUM_THREADS; i++){
		r = pthread_create(&tid, NULL, thread_func, (void*) &message[i]);
		thread_id[i] = tid;
	}

	//printf("Threads einsammeln:\n");
	for(i=0; i<NUM_THREADS; i++){
		r = pthread_join(thread_id[i], NULL);
	}
	// Addiere Teilsummen
	double res=0;
	for (int i=0; i<NUM_THREADS; i++){
		res += message[i].sum; 
	}
	//std::cout << "Ergebnis: " << res << std::endl;
	//std::cout << "Referenz-Ergebnis:" << std::inner_product(&a[0], &a[n], &b[0], 0.0) << std::endl;
	return res;

}

main(){
	int n = 500000;
	double a[n];
	double b[n];
	// Initialisiere Vektoren
	for (int i=0;i<n;i++){
		a[i] = i;
		b[i] = n-i;	
	}

	double res;
	auto start = system_clock::now();
	for (int i=0;i<2000;i++){
		res = threaded_scalar_product(&a[0], &b[0], n);
	}
	auto end = system_clock::now();
	const double elapsed_seconds = duration<double>(end - start).count();
	std::cout << "Ergebnis: " << res << std::endl;
	std::cout << "Laufzeit in Sekunden:" << elapsed_seconds << std::endl;
	

}



