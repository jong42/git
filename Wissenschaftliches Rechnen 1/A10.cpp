#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <iostream>

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
	//std::cout << "Parameter:" << " " << *(message.b+1) << std::endl;

	(* (messagetype*) param).sum = scalar_product(message.a,message.b,message.n);
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
	int i, r;
	pthread_t tid, thread_id[NUM_THREADS];
	messagetype message[NUM_THREADS];
	printf("Threads starten:\n");

	for(i=0; i<NUM_THREADS; i++){
		message[i].a = &a[i*n/NUM_THREADS];
		message[i].b = &b[i*n/NUM_THREADS];
		message[i].n = n/NUM_THREADS;
		r = pthread_create(&tid, NULL, thread_func, (void*) &message[i]);
		thread_id[i] = tid;
	}

	printf("Threads einsammeln:\n");
	for(i=0; i<NUM_THREADS; i++){
		r = pthread_join(thread_id[i], NULL);
	}
	for (i=0; i<NUM_THREADS; i++){
		std::cout << "Teilsumme: " << message[i].sum << std::endl;
	}
}

//TODO: Rundungsfehler bei Berechnung von n korrigieren
//TODO: Teilsummen aufaddieren
