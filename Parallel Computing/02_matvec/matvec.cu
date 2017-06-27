#include <cuda.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define DTYPE float

__global__ void kernelAx(DTYPE *a, DTYPE *x, DTYPE *y, int size)
{
   //Hier soll die GPU A*x=y berechnen

	int tid = threadIdx.x;    //lokaler Thread Index
    int bid = blockIdx.x;     //Index des Blockes
    int bdim= blockDim.x;     //Anzahl an Threads pro Block
    
    int i = tid+bid*bdim;     //Globale Adresse

    for (int j = 0; j < size; j++){
        y[i] += a[i*size+j]*x[j];
	}
		

}



__global__ void kernelAx_sm(DTYPE *a, DTYPE *x, DTYPE *y, int size, int k)
{
	int tid = threadIdx.x;    //lokaler Thread Index
    int bid = blockIdx.x;     //Index des Blockes
    int bdim= blockDim.x;     //Anzahl an Threads pro Block
    
    int gid = tid+bid*bdim;     //Globale Adresse
      
    // shared mem-Grösse gleich der Blockanzahl
    __shared__ float sm[512];
    
    
    // Jeder Thread rechnet ein Zwischenergebnis aus
    sm[tid] = a[gid+k*size]*x[gid];
    __syncthreads();

	// Reduktion
	for (int i=blockDim.x/2;i>0;i=i/2)
	{
       if (tid<i)
           sm[tid]+=sm[tid+i];
       __syncthreads();
	}

	// Übertragen des Ergebnisses
	if (tid==0)
	{
		atomicAdd(&y[k],sm[0]);
	}
	


    

	
}


__global__ void kernelATx(DTYPE *a, DTYPE *x, DTYPE *y, int size)
{
    //Hier soll die GPU A^T*x=y berechnen
   
	int tid = threadIdx.x;    //lokaler Thread Index
    int bid = blockIdx.x;     //Index des Blockes
    int bdim= blockDim.x;     //Anzahl an Threads pro Block
    
    int i = tid+bid*bdim;     //Globale Adresse

    for (int j = 0; j < size; j++){
        y[i] += a[i+size*j]*x[j];
	}
	
}

__global__ void kernelATx_sm(DTYPE *a, DTYPE *x, DTYPE *y, int size, int k)
{
	//Hier soll die GPU A^T*x=y mit shared memory berechnen
	
	int tid = threadIdx.x;    //lokaler Thread Index
    int bid = blockIdx.x;     //Index des Blockes
    int bdim= blockDim.x;     //Anzahl an Threads pro Block
    
    int gid = tid+bid*bdim;     //Globale Adresse
      
    // shared mem-Grösse gleich der Blockanzahl
    __shared__ float sm[512];
    
  
    // Jeder Thread rechnet ein Zwischenergebnis aus
    sm[tid] = a[gid*size+k]*x[gid];
    __syncthreads();

	// Reduktion
	for (int i=blockDim.x/2;i>0;i=i/2)
	{
       if (tid<i)
           sm[tid]+=sm[tid+i];
       __syncthreads();
	}

	// Übertragen des Ergebnisses
	if (tid==0)
	{
		atomicAdd(&y[k],sm[0]);
	}
}


__global__ void kernelAx_sm_dp(DTYPE *a, DTYPE *x, DTYPE *y, int size, dim3 grid, dim3 threads)
{	
	//Hier soll die GPU A*x=y mit shared memory und dynamic parallelism berechnen
	
	int tid = threadIdx.x;    //lokaler Thread Index
    int bid = blockIdx.x;     //Index des Blockes
    int bdim= blockDim.x;     //Anzahl an Threads pro Block
    
    int gid = tid+bid*bdim;     //Globale Adresse
    
	kernelAx_sm<<<grid,threads>>>(a,x,y,size,gid);
	
}

__global__ void kernelATx_sm_dp(DTYPE *a, DTYPE *x, DTYPE *y, int size, dim3 grid, dim3 threads)
{
	//Hier soll die GPU A^T*x=y mit shared memory und dynamic parallelism berechnen
	
	int tid = threadIdx.x;    //lokaler Thread Index
    int bid = blockIdx.x;     //Index des Blockes
    int bdim= blockDim.x;     //Anzahl an Threads pro Block
    
    int gid = tid+bid*bdim;     //Globale Adresse
    
	kernelATx_sm<<<grid,threads>>>(a,x,y,size,gid);
}

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

void hostAx(DTYPE *a, DTYPE *x, DTYPE *y, int size)
{
   // Hier soll der Host A*x=y berechnen
	for (int i = 0;i<size;i++) {
		y[i] = 0;
		for (int j = 0;j<size;j++) {
			y[i] += a[i*size+j] * x[j];
		}
	}
}

void hostATx(DTYPE *a, DTYPE *x, DTYPE *y, int size)
{
   // Hier soll der Host A^T*x=y berechnen
	for (int i = 0;i<size;i++) {
		y[i] = 0;
		for (int j = 0;j<size;j++) {
			y[i] += a[i+size*j] * x[j];
		}
	}
}



bool checkResult(DTYPE *yh_ax, DTYPE *yh_atx, DTYPE *yd_ax, DTYPE *yd_atx, DTYPE *yd_ax_sm, DTYPE *yd_atx_sm, DTYPE *yd_ax_sm_dp, DTYPE *yd_atx_sm_dp, int size)
{
   bool res=true;
   for (int i=0;i<size;i++)
   {
      res&=(yh_ax[i]==yd_ax[i]);
      if (i<10) printf("%f %f %f %f %f %f %f %f\n",yh_ax[i],yh_atx[i],yd_ax[i],yd_atx[i],yd_ax_sm		 			[i],yd_atx_sm[i],yd_ax_sm_dp[i],yd_atx_sm_dp[i]);
   }
   return res;
}

/*
   Main Routine: 
   Input: i,[threads]
   Berechnet A*x=y auf der GPU/CPU wobei A eine Größe von R^{n x n} hat, mit
   n=1024*i
*/
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
   DTYPE *a_host,*x_host, *yh_ax_host, *yh_atx_host, *yd_ax_host, *yd_atx_host, *yd_ax_sm_host, 		*yd_atx_sm_host,*yd_ax_sm_dp_host,*yd_atx_sm_dp_host;
   //und Device
   DTYPE *a_dev, *y_dev,*x_dev;
   //Events für die Zeitmessung
   cudaEvent_t start,end;
   //Zeiten: 
   //htd: Host->Device Memcpy von A und x
   float htd_time=0.0;
   //dth: Device->Host Memcpy von y
   float dth_time=0.0;
   //kernelA, kernelAT, kernelA_sm
   float kernelA_time=0.0;
   float kernelAT_time=0.0;
   float kernelA_sm_time=0.0;
   float kernelAT_sm_time=0.0;
   float kernelA_sm_dp_time=0.0;
   float kernelAT_sm_dp_time=0.0;

   //Host Speicher anlegen und A und x füllen
	a_host = (DTYPE*)malloc(size*size*sizeof(DTYPE));
	x_host = (DTYPE*)malloc(size*sizeof(DTYPE));
	yh_ax_host = (DTYPE*)malloc(size*sizeof(DTYPE));
	yh_atx_host = (DTYPE*)malloc(size*sizeof(DTYPE));
	yd_ax_host = (DTYPE*)malloc(size*sizeof(DTYPE));
	yd_atx_host = (DTYPE*)malloc(size*sizeof(DTYPE));
	yd_ax_sm_host = (DTYPE*)malloc(size*sizeof(DTYPE));
	yd_atx_sm_host = (DTYPE*)malloc(size*sizeof(DTYPE));
	yd_ax_sm_dp_host = (DTYPE*)malloc(size*sizeof(DTYPE));
	yd_atx_sm_dp_host = (DTYPE*)malloc(size*sizeof(DTYPE));
	fillA(a_host,size);
	fillX(x_host,size);

   //CUDA Events erstellen
	cudaEventCreate(&start);
	cudaEventCreate(&end);

   //CUDA Speicher anlegen für alle Arrays (a_dev,x_dev,y_dev)
	cudaMalloc((void**)&a_dev,size*size*sizeof(DTYPE));
	cudaMalloc((void**)&x_dev,size*sizeof(DTYPE));
	cudaMalloc((void**)&y_dev,size*sizeof(DTYPE));

   //Host->Device Memcpy von A und x + Zeitmessung
	cudaEventRecord(start);
    cudaMemcpy(a_dev,a_host,size*size*sizeof(DTYPE),cudaMemcpyHostToDevice);
    cudaMemcpy(x_dev,x_host,size*sizeof(DTYPE),cudaMemcpyHostToDevice);
	cudaEventRecord(end);
	cudaEventSynchronize(end);
	cudaEventElapsedTime(&htd_time,start,end);

   //Konfiguration der CUDA Kernels
	cudaMemset(y_dev, 0,size*sizeof(DTYPE));
   dim3 threads(t);
   dim3 grid(size/threads.x);
   
   // CacheConfig-Befehle
   cudaFuncSetCacheConfig(kernelAx,cudaFuncCachePreferL1);
   cudaFuncSetCacheConfig(kernelATx,cudaFuncCachePreferL1);
   cudaFuncSetCacheConfig(kernelAx_sm,cudaFuncCachePreferL1);
   cudaFuncSetCacheConfig(kernelATx_sm,cudaFuncCachePreferL1);
   cudaFuncSetCacheConfig(kernelAx_sm_dp,cudaFuncCachePreferL1);
   cudaFuncSetCacheConfig(kernelATx_sm_dp,cudaFuncCachePreferL1);
   
   // kernelAx ausführen und Zeit messen
	cudaEventRecord(start);
   	kernelAx<<<grid,threads>>>(a_dev,x_dev,y_dev,size);
	cudaEventRecord(end);
	cudaEventSynchronize(end);
	cudaEventElapsedTime(&kernelA_time,start,end);

   // Device->Host Memcpy für y_dev -> yd_ax_host
	cudaEventRecord(start);
  	cudaMemcpy(yd_ax_host,y_dev,size*sizeof(DTYPE),cudaMemcpyDeviceToHost);
	cudaEventRecord(end);
	cudaEventSynchronize(end);
	cudaEventElapsedTime(&dth_time,start,end);
	
	// kernelAx_sm mit shared memory ausführen und Zeit messen
	cudaMemset(y_dev, 0,size*sizeof(DTYPE));
	cudaEventRecord(start);
	//printf("xedv: %d", x_dev);
	for (int k=0;k<size;k++)
	{
		kernelAx_sm<<<grid,threads>>>(a_dev,x_dev,y_dev,size,k);
	}
	cudaEventRecord(end);
	cudaEventSynchronize(end);
	cudaEventElapsedTime(&kernelA_sm_time,start,end);

   // Device->Host Memcpy für y_dev -> yd_ax_sm_host
	cudaEventRecord(start);
  	cudaMemcpy(yd_ax_sm_host,y_dev,size*sizeof(DTYPE),cudaMemcpyDeviceToHost);
	cudaEventRecord(end);
	cudaEventSynchronize(end);
	cudaEventElapsedTime(&dth_time,start,end);

   //: kernelATx ausführen und Zeit messen
   	cudaMemset(y_dev, 0,size*sizeof(DTYPE));
   	cudaEventRecord(start);
   	kernelATx<<<grid,threads>>>(a_dev,x_dev,y_dev,size);
	cudaEventRecord(end);
	cudaEventSynchronize(end);
	cudaEventElapsedTime(&kernelAT_time,start,end); 

   // Device->Host Memcpy für y_dev -> yd_atx_host
	cudaEventRecord(start);
  	cudaMemcpy(yd_atx_host,y_dev,size*sizeof(DTYPE),cudaMemcpyDeviceToHost);
	cudaEventRecord(end);
	cudaEventSynchronize(end);
	cudaEventElapsedTime(&dth_time,start,end);

   // kernelATx_sm mit shared memory ausführen und Zeit messen
   	cudaMemset(y_dev, 0,size*sizeof(DTYPE));
   	cudaEventRecord(start);
   	for (int k=0;k<size;k++)
	{
		kernelATx_sm<<<grid,threads>>>(a_dev,x_dev,y_dev,size,k);
	}
	cudaEventRecord(end);
	cudaEventSynchronize(end);
	cudaEventElapsedTime(&kernelAT_sm_time,start,end); 

   // Device->Host Memcpy für y_dev -> yd_atx_sm_host
	cudaEventRecord(start);
  	cudaMemcpy(yd_atx_sm_host,y_dev,size*sizeof(DTYPE),cudaMemcpyDeviceToHost);
	cudaEventRecord(end);
	cudaEventSynchronize(end);
	cudaEventElapsedTime(&dth_time,start,end);
	
	// kernelAx_sm mit shared memory und dynamic parallelism ausführen und Zeit messen
   	cudaMemset(y_dev, 0,size*sizeof(DTYPE));
   	cudaEventRecord(start);
   	kernelAx_sm_dp<<<grid,threads>>>(a_dev,x_dev,y_dev,size,grid,threads);
	cudaEventRecord(end);
	cudaEventSynchronize(end);
	cudaEventElapsedTime(&kernelA_sm_dp_time,start,end);
	
	// Device->Host Memcpy für y_dev -> yd_ax_sm_dp_host
	cudaEventRecord(start);
  	cudaMemcpy(yd_ax_sm_dp_host,y_dev,size*sizeof(DTYPE),cudaMemcpyDeviceToHost);
	cudaEventRecord(end);
	cudaEventSynchronize(end);
	cudaEventElapsedTime(&dth_time,start,end);
	
	// kernelATx_sm mit shared memory und dynamic parallelism ausführen und Zeit messen
   	
   	cudaMemset(y_dev, 0,size*sizeof(DTYPE));
   	cudaEventRecord(start);
   	kernelATx_sm_dp<<<grid,threads>>>(a_dev,x_dev,y_dev,size,grid,threads);
	cudaEventRecord(end);
	cudaEventSynchronize(end);
	cudaEventElapsedTime(&kernelAT_sm_dp_time,start,end);
	
	// Device->Host Memcpy für y_dev -> yd_atx_sm_dp_host
	cudaEventRecord(start);
  	cudaMemcpy(yd_atx_sm_dp_host,y_dev,size*sizeof(DTYPE),cudaMemcpyDeviceToHost);
	cudaEventRecord(end);
	cudaEventSynchronize(end);
	cudaEventElapsedTime(&dth_time,start,end);  
	
   printf("GPU timing in ms: h->d: %f kernelAx: %f kernelATx: %f kernelAx_sm: %f kernelATx_sm: %f kernelAx_sm_dp: %f kernelATx_sm_dp: %f d->h: %f\n",htd_time,kernelA_time,kernelAT_time,kernelA_sm_time,kernelAT_sm_time,kernelA_sm_dp_time,kernelAT_sm_dp_time,dth_time);


   //Nutzen hier timespec um CPU Zeit zu messen
   struct timespec start_h,end_h;
   double hostA_time, hostAT_time;

   clock_gettime(CLOCK_PROCESS_CPUTIME_ID,&start_h);
   //A*x auf Host
	hostAx(a_host, x_host, yh_ax_host, size);

   clock_gettime(CLOCK_PROCESS_CPUTIME_ID,&end_h);
   hostA_time=(double)((end_h.tv_nsec+end_h.tv_sec*1E9) - (start_h.tv_nsec+start_h.tv_sec*1E9))/1E6;
   
   clock_gettime(CLOCK_PROCESS_CPUTIME_ID,&start_h);
   //A^T*x auf Host
	hostATx(a_host, x_host, yh_atx_host, size);

   clock_gettime(CLOCK_PROCESS_CPUTIME_ID,&end_h);
   hostAT_time=(double)((end_h.tv_nsec+end_h.tv_sec*1E9) - (start_h.tv_nsec+start_h.tv_sec*1E9))/1E6;

   printf("CPU timing in ms: Ax: %f  ATx: %f\n",hostA_time, hostAT_time);

   //checkResult aufrufen
	printf("   CPU_Ax   ;    CPU_Atx   ;    GPU_Ax   ;    GPU_Atx   ;   GPU_Ax_sm ;  GPU_Atx_sm ;GPU_Ax_sm_dp;GPU_ATx_sm_dp  ;\n");
	printf("  %f      %f      %f      %f      %f      %f    %f     %f\n",hostA_time, hostAT_time, kernelA_time, kernelAT_time, kernelA_sm_time, kernelAT_sm_time,  kernelA_sm_dp_time,  kernelAT_sm_dp_time);
	checkResult(yh_ax_host, yh_atx_host, yd_ax_host, yd_atx_host, yd_ax_sm_host, yd_atx_sm_host, yd_ax_sm_dp_host, yd_atx_sm_dp_host, size);

   //Speicher freigeben (Host UND Device)
   cudaFree(a_dev);
   cudaFree(x_dev);
   cudaFree(y_dev);
   free(a_host);
   free(x_host);
   free(yh_ax_host);
   free(yh_atx_host);
   free(yd_ax_host);
   free(yd_atx_host);
   free(yd_ax_sm_host);
   free(yd_atx_sm_host);

   
   //CUDA Events zerstören
	cudaEventDestroy(start);
	cudaEventDestroy(end);

   return 0;
}
