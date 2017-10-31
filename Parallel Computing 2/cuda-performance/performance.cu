#include <stdio.h>
#include <cuda.h>
#include <stdlib.h>

__global__ void kernel_atomics(float* a, float *b, int x, int y)
{
   int i=threadIdx.x+blockIdx.x*blockDim.x;
   int j=threadIdx.y+blockIdx.y*blockDim.y;

   if (i<x && j<y)
   {
      atomicAdd(&b[j],a[i+j*x]);
   }
}



__global__ void kernel_shared(float *a, float *b, int x, int y)
{
   int i=threadIdx.x+blockIdx.x*blockDim.x;
   int j=threadIdx.y+blockIdx.y*blockDim.y;
   extern __shared__ float sm[];
   if (i<x && j<y)
   {
      sm[threadIdx.x+threadIdx.y*blockDim.x]=a[i+j*x];
      __syncthreads();
      for (int k=blockDim.x/2;k>0;k/=2)
      {
         if (threadIdx.x<k)
            sm[threadIdx.x+threadIdx.y*blockDim.x]+=sm[threadIdx.x+k+threadIdx.y*blockDim.x];
         __syncthreads();
      }
      if (threadIdx.x==0)
         atomicAdd(&b[j],sm[threadIdx.y*blockDim.x]);
   }
}





#define WARP_SIZE 32
__global__ void kernel_shfl(const float *a, float *b,const int x,const int y)
{
   int i=threadIdx.x+blockIdx.x*blockDim.x;
   int j=threadIdx.y+blockIdx.y*blockDim.y;
   float res=0.0f;
   __shared__ float sm[32];
   if (threadIdx.x<WARP_SIZE)
      sm[threadIdx.x]=0;
   __syncthreads();
   if (j<y)
   {
      for (int k=i;k<x;k+=blockDim.x*gridDim.x)
      {
         res+=a[k+j*x];
      }
      #pragma unroll
      for (int mask=WARP_SIZE/2;mask>0;mask>>=1)
      {
         res+=__shfl_down(res,mask);
      }
      if (threadIdx.x%WARP_SIZE==0)
      {
         sm[threadIdx.x/WARP_SIZE]=res;
      }
      __syncthreads();
      if (threadIdx.x<WARP_SIZE)
      {
         res=sm[threadIdx.x];
         #pragma unroll
         for (int mask=WARP_SIZE/2;mask>0;mask>>=1)
         {
            res+=__shfl_down(res,mask);
         }
      }
      if (threadIdx.x==0)
      {
         //atomicAdd(&b[j],res);
         b[j]=res;
      }
   }
}












void initA(float *a, int sx, int sy)
{
    for(int j=0;j<sy;j++)
    {
       for (int i=0;i<sx;i++)
       {
          a[i+j*sx]=(float)(i+1)/(j+1);
       }
    }
}

int checkResults(float *a, float *b, int sx, int sy)
{
   float error=0.0;
   for (int j=0;j<sy;j++)
   {
      float sum=0.0;
      for (int i=0;i<sx;i++)
      {
         sum+=a[i+j*sx];
      }
      error=max(error,abs(1-(b[j]/sum)));
      if (abs(1-(b[j]/sum))>1e-4)
      {
         printf("Error occured in execution in line %i (%f!=%f)\n",j,b[j],sum);
         return(-1);
      }
   }
   printf("Test passed! Max relative error was %f\n",error);
   return 0;
}

int main(int argc, char ** argv)
{
   int sx=8192;
   int sy=4096;
   if (argc>2)
   {
      sx=(int)atoi(argv[1]);
      sy=(int)atoi(argv[2]);
   }
   float *a,*b,*a_dev,*b_dev;
   //Memory Management
   a=(float*)malloc(sx*sy*sizeof(float));
   b=(float*)malloc(sy*sizeof(float));
   initA(a,sx,sy);
   cudaMalloc((void**)&a_dev,sx*sy*sizeof(float));
   cudaMalloc((void**)&b_dev,sy*sizeof(float));
   cudaMemcpy(a_dev,a,sx*sy*sizeof(float),cudaMemcpyHostToDevice);
   cudaMemset(b_dev,0,sy*sizeof(float));
   cudaError_t err=cudaGetLastError();
   if (err!=cudaSuccess)
   {
      printf("An Error occured in Memory Management: %s (%i)\n",cudaGetErrorString(err),err);
      return(-1);
   }
   dim3 block(1,256);
   dim3 grid((int)ceilf((float)sx/block.x),(int)ceilf((float)sy/block.y));
   //Kernel Execution Atomics Global
   cudaMemset(b_dev,0,sy*sizeof(float));
   kernel_atomics<<<grid,block>>>(a_dev,b_dev,sx,sy);
   cudaDeviceSynchronize();
   err=cudaGetLastError();
   if (err!=cudaSuccess)
   {
      printf("An Error occured in Atomics Kernel Execution: %s (%i)\n",cudaGetErrorString(err),err);
      return(-1);
   }

   cudaMemcpy(b,b_dev,sy*sizeof(float),cudaMemcpyDeviceToHost);
   int result=checkResults(a,b,sx,sy);

   //Kernel Execution SM
   block.x=32;
   block.y=8;
   grid.x=(int)ceilf((float)sx/block.x);
   grid.y=(int)ceilf((float)sy/block.y);
   cudaMemset(b_dev,0,sy*sizeof(float));
   kernel_shared<<<grid,block,block.x*block.y*sizeof(float)>>>(a_dev,b_dev,sx,sy);
   cudaDeviceSynchronize();
   err=cudaGetLastError();
   if (err!=cudaSuccess)
   {
      printf("An Error occured in Shared Kernel Execution: %s (%i)\n",cudaGetErrorString(err),err);
      return(-1);
   }

   cudaMemcpy(b,b_dev,sy*sizeof(float),cudaMemcpyDeviceToHost);
   result=checkResults(a,b,sx,sy);

   //execute performance optimized code

   //Use shuffle instead of sm and 1 Block in x direction 
   cudaMemset(b_dev,0,sy*sizeof(float));
   block.x=128;
   block.y=1;
   grid.x=1;
   grid.y=sy;
   cudaFuncSetCacheConfig(kernel_shfl,cudaFuncCachePreferL1);
   kernel_shfl<<<grid,block>>>(a_dev,b_dev,sx,sy);
   cudaDeviceSynchronize();
   err=cudaGetLastError();
   if (err!=cudaSuccess)
   {
      printf("An Error occured in Shuffle Kernel Execution: %s (%i)\n",cudaGetErrorString(err),err);
      return(-1);
   }

   cudaMemcpy(b,b_dev,sy*sizeof(float),cudaMemcpyDeviceToHost);
   result=checkResults(a,b,sx,sy);
   free(a);
   free(b);
   cudaFree(a_dev);
   cudaFree(b_dev);
   return result;
}
