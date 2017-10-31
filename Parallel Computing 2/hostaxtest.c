#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define DTYPE float

//A mit Werten füllen (hier einfach 1en)
void fillA(DTYPE *a, int size)
{
   for (int i=0;i<size*size;i++)
      a[i]=1.0;
}

//X mit Werten füllen 
void fillX(DTYPE *x, int size)
{
   for (int i=0;i<size;i++)
      x[i]= (DTYPE)(i+1);
}

float hostAx(DTYPE a, DTYPE x)
{
   //TODO: Hier soll der Host A*x=y berechnen
	float res;
	res = a * x;
	return res;

}

bool checkResult(DTYPE *yh, DTYPE *yd, int size)
{
   bool res=true;
   for (int i=0;i<size;i++)
   {
      res&=(yh[i]==yd[i]);
      if (i<10) printf("%f %f\n",yh[i],yd[i]);
   }
   return res;
}

int main(int argc, char**argv)
{
	int i=1;
	int t=512;
	if (argc>1)
   	{
      i=atoi(argv[1]);
      if (argc>2) t=atoi(argv[2]);
   	}
	else 
	{
      printf("Usage: %s i [threads] \n",argv[0]);
      return -1;
	}
   	int size=1024*i;

   //Datenfelder anlegen für Host
	DTYPE *a_host, *yd_host, *yh_host,*x_host;

   //TODO: Host Speicher anlegen und A und x füllen
	a_host = (DTYPE*)malloc(size*size*sizeof(DTYPE));
	x_host = (DTYPE*)malloc(size*sizeof(DTYPE));
	yd_host = (DTYPE*)malloc(size*sizeof(DTYPE));
	yh_host = (DTYPE*)malloc(size*sizeof(DTYPE));
	fillA(a_host,size);
	fillX(x_host,size);

   
   //TODO: A*x auf Host
	for (int i = 0;i<size;i++) {
		yh_host[i] = 0;
	}
	for (int i = 0;i<size;i++) {
		for (int j = 0;j<size;j++) {
			yh_host[i] += hostAx(a_host[i*size+j], x_host[j]);
		};
	};
	//for (int i=0;i<size;i++)
   	//{
    //  if (i<10) printf("%f\n",yh_host[i]);
   	//};
	for (int i=0;i<size;i++)
   	{
      printf("%f\n",x_host[i]);
   	};
}
