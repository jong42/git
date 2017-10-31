#include <stdio.h>
#include <cuda.h>
#include <stdlib.h>

__global__ void kernel(float *a, float *b, int x, int y)
{
   int i=threadIdx.x+blockIdx.x*blockDim.x;
   int j=threadIdx.y+blockIdx.y*blockDim.y;
   __shared__ float sm[256];
   if (i<x && j<y)
   {
      sm[threadIdx.x+threadIdx.y*blockDim.x]=a[i+j*x];
      __syncthreads();
      for (int k=blockDim.x/2;k>0;k=k/2)
      {
         if (threadIdx.x<k)
             sm[threadIdx.x+threadIdx.y*blockDim.x]+=sm[threadIdx.x+k+threadIdx.y*blockDim.x];
         __syncthreads();
      }
      if (threadIdx.x==0)
         atomicAdd(&b[j],sm[threadIdx.x+threadIdx.y*blockDim.x]);
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
   for (int j=0;j<sy;j++)
   {
      float sum=0.0;
      for (int i=0;i<sx;i++)
      {
         sum+=a[i+j*sx];
      }
      if (fabs(b[j] - sum) > 0.0001)
      {
         printf("Error occured in execution in line %i\n",j);
         return(-1);
      }
   }
   return 0;
}

int main()
{
   int sx=64;
   int sy=48;
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
   //Kernel Execution
   dim3 block(32,8);
   dim3 grid(sx/block.x,sy/block.y);
   kernel<<<grid,block>>>(a_dev,b_dev,sx,sy);
   cudaDeviceSynchronize();
   err=cudaGetLastError();
   if (err!=cudaSuccess)
   {
      printf("An Error occured in Kernel Execution: %s (%i)\n",cudaGetErrorString(err),err);
      return(-1);
   }

   cudaMemcpy(b,b_dev,sy*sizeof(float),cudaMemcpyDeviceToHost);
   int result=checkResults(a,b,sx,sy);
   free(a);
   free(b);
   cudaFree(a_dev);
   cudaFree(b_dev);
   return result;
}
