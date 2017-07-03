#include <stdio.h>
#include <time.h>
#include <math.h>


void matvec_row(int y[], int a[], int x[], int dim)
{
	int i,j;
	for(i=0;i<dim;i++)
	{
		y[i] = 0;
		for(j=0;j<dim;j++)
		{
			y[i] += a[i*dim+j]*x[j];
		}
	}
	
}

void matvec_col(int y[], int a[], int x[], int dim)
{
	int i,j;
	for(i=0;i<dim;i++)
	{
		y[i] = 0;
		for(j=0;j<dim;j++)
		{
			y[i] += a[i+dim*j]*x[j];
		}
	}
	
}

void matvec_fivepointstar(int y[], int h, int x[], int dim)
{
	h = 1;
	int i,j;
	for(i=0;i<dim;i++)
	{
		y[i] = 0;
		y[i] += 4*x[i];
		if (i+3<dim)
		{
			y[i] += -x[i+3];
			if (i+1<dim && i % (int)(sqrt(dim)) != 0)
			{
				y[i] += -x[i+1];
			}
		}
		if (i-3>=0)
		{
			y[i] += -x[i-3];
			if (i-1>=0 && i % (int)(sqrt(dim)) != 1)
			{
				y[i] += -x[i-1];
			}
		}
	}
	
}

void matvec_CRS(int y[], int a[], int ia[], int ja[], int x[],int dim)
{	int counter;
	for (int i=0;i<dim;i++)
	counter = 0;
	{
		// Iteriere durch ia, bis Element von ia >= i+1. Der (Index des Elements)-1 
		// ist der aufzuaddierende Index von y
		for (int j=1;ia[j]<i+1;j++)
		{
			counter = j-1;
		}

		//
		y[counter]+= a[i]*x[ja[i]];
	}
	
}

int main()
{	
	int dim = 9;
	int mat[dim*dim],i;
	int vec[dim];
	int y[dim];
	struct timespec start_h,end_h;
	long a1_ops,a2_ops,b_ops,c_ops;
	double a1_time, a2_time, b_time, c_time;
	
	int repeats = 10000;

	// Initialisiere Matrix und Vektor
	for (i=0; i<dim; i++)
    {
		vec[i]=i+1;
		//printf("%d", vec[i]);
	}
	
    for (i=0; i<(dim*dim); i++)
    {
        mat[i] = 1;
        //printf("%d", a1[i]);
    }
    
    // Erstelle CRS Matrix
    int a[7]; 
    int ia[10];
    int ja[7];    
    a[0] = 5;
    a[1] = 8;
    a[2] = 3;
    a[3] = 6;
    a[4] = 9;
    a[5] = 1;
    a[6] = 7;
    ia[0] = 0;
    ia[1] = 0;
    ia[2] = 2;
    ia[3] = 3;
    ia[4] = 4;
    ia[5] = 5;
    ia[6] = 6;
    ia[7] = 6;
    ia[8] = 6;
    ia[9] = 7;
	ja[0] = 0;
	ja[1] = 1;
	ja[2] = 2;
	ja[3] = 1;
	ja[4] = 5;
	ja[5] = 3;
	ja[6] = 6;
	//
    
    
	// Führe die verschiedenen Varianten aus
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID,&start_h);
    for (i=0;i<repeats;i++)
    {
		matvec_row(y,mat,vec,dim);
    }
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID,&end_h);
    a1_time=(double)((end_h.tv_nsec+end_h.tv_sec*1E9) - (start_h.tv_nsec+start_h.tv_sec*1E9))/1E6;
    
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID,&start_h);
    for (i=0;i<repeats;i++)
    {
    matvec_col(y,mat,vec,dim);
	}
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID,&end_h);
    a2_time=(double)((end_h.tv_nsec+end_h.tv_sec*1E9) - (start_h.tv_nsec+start_h.tv_sec*1E9))/1E6;
    
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID,&start_h);
    for (i=0;i<repeats;i++)
    {
    matvec_fivepointstar(y,1,vec,dim);
	}
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID,&end_h);
    b_time=(double)((end_h.tv_nsec+end_h.tv_sec*1E9) - (start_h.tv_nsec+start_h.tv_sec*1E9))/1E6;
    
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID,&start_h);
    for (i=0;i<repeats;i++)
    {
    matvec_CRS(y,a,ia,ja,vec,dim);
	}
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID,&end_h);
    c_time=(double)((end_h.tv_nsec+end_h.tv_sec*1E9) - (start_h.tv_nsec+start_h.tv_sec*1E9))/1E6;

        
    a1_ops = 4*dim*dim;
    a2_ops = 4*dim*dim;
    b_ops = 6*dim;
    c_ops = 2*dim;
    
    
    for (i=0; i<dim; i++)
    {
        //printf("%d", y[i]);
        //printf("\n");
    }
    printf("a1_time:%f a1_ops:%d a1_flops/s: %f \n",a1_time, a1_ops, a1_ops/a1_time);
    printf("a2_time:%f a2_ops:%d a2_flops/s: %f \n",a2_time, a2_ops, a2_ops/a2_time);
    printf("b_time:%f b_ops:%d b_flops/s: %f \n",b_time, b_ops, b_ops/b_time);
    printf("c_time:%f c_ops:%d c_flops/s: %f \n",c_time, c_ops, c_ops/c_time);
    
    return 0;
        
}
