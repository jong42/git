
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>


/*  Das Programm enthält verschiedene Aufgaben.
    Parallelisieren Sie die einzelnen Abschnitte mit geeigneten OpenMP-Direktiven.
*/


/* 1. */
int check1(double *y, double **A, double *x, int n, int m)
{
    int i,j;
    double *yt = (double *) malloc(m * sizeof(double));

    int check=1;
    for (i=0; i<m; i++) {
        yt[i] = 0;
        for (j=0; j<n; j++) {
            yt[i] += A[i][j] * x[j];
        }
        if (y[i]!=yt[i]) check=0;
    }
    return check;
}
/* 2. */
int check2(double *y, double **A, double *x, double s, int n, int m)
{
    int i,j;
    double *yt = (double *) malloc(m * sizeof(double));

    int check=1;

    double st = 0.0;
    for (i=0; i<m; i++) {
        yt[i] = 0;
        for (j=0; j<n; j++) {
            yt[i] += A[i][j] * x[j];
        }
        st += yt[i];
    }
    if (s!=st) check=0;
    return check;
}

/* 3. */
int check3(double *y, double **A, double *x, int n, int m)
{
    int i,j;
    double *yt = (double *) malloc(m * sizeof(double));

    int check=1;
    yt[0] = 0;
    for (i=1; i<m; i++) {
        yt[i] = yt[i-1];
        for (j=0; j<n; j++) {
            yt[i] += A[i][j] * x[j];
        }
        if (yt[i]!=y[i]) check=0;
    }
    return check;
}

/* 4. */
int check4(double *y, double **A, double *x, int n, int m)
{
    int i,j;
    double *yt = (double *) malloc(m * sizeof(double));

    double *alpha = (double *) malloc(m * sizeof(double));

    int check=1;
    for (i=0; i<m; i++) {
        yt[i] = 0;
        for (j=0; j<n; j++) {
            yt[i] += A[i][j] * x[j];
        }
    }

    for (i=0; i<m; i++) {
        alpha[i] = A[i][0] * A[i][1];
    }

    for (i=0; i<m; i++) {
        yt[i] *= alpha[i];
        if (yt[i]!=y[i]) check=0;
    }
    return check;
}

int main() {

    int m = 1000;
    int n = 2000;
    int i;
    int j;

    double *y = (double *) malloc(m * sizeof(double));
    double *x = (double *) malloc(n * sizeof(double));
    double **A = (double **) malloc(m * sizeof(double *));
    for (i=0; i<m; i++) {
		x[i] = i / 2;
        A[i] = (double *) malloc(n * sizeof(double));
		for (j=0; j<n; j++) {
			A[i][j] = i*j;
		}
    }

    
    /* 1. */
    #pragma omp parallel for
    for (i=0; i<m; i++) {
        y[i] = 0;
        for (j=0; j<n; j++) {
            y[i] += A[i][j] * x[j];
        }
    }

    if (!check1(y,A,x,n,m))
    {
       printf("Aufgabe 1 liefert Fehler!\n");
       return 0;
    }


    /* 2. */
    double s = 0.0;
    for (i=0; i<m; i++) {
        y[i] = 0;
        for (j=0; j<n; j++) {
            y[i] += A[i][j] * x[j];
        }
        s += y[i];
    }
    if (!check2(y,A,x,s,n,m))
    {
       printf("Aufgabe 2 liefert Fehler!\n");
       return 0;
    }

    
    /* 3. */
    y[0] = 0;
    for (i=1; i<m; i++) {
        y[i] = y[i-1];
        for (j=0; j<n; j++) {
            y[i] += A[i][j] * x[j];
        }
    }
    if (!check3(y,A,x,n,m))
    {
       printf("Aufgabe 3 liefert Fehler!\n");
       return 0;
    }


    /* 4. */
    double *alpha = (double *) malloc(m * sizeof(double));

    for (i=0; i<m; i++) {
        y[i] = 0;
        for (j=0; j<n; j++) {
            y[i] += A[i][j] * x[j];
        }
    }

    for (i=0; i<m; i++) {
        alpha[i] = A[i][0] * A[i][1];
    }

    for (i=0; i<m; i++) {
        y[i] *= alpha[i];
    }

    if (!check4(y,A,x,n,m))
    {
       printf("Aufgabe 4 liefert Fehler!\n");
       return 0;
    }

    printf("All tests passed!\n");

    return 0;

}
