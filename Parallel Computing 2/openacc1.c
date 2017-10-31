# pragma acc data copyin(x,y) copyout(z)
{
...
	#pragma acc parallel
	{
	#pragma acc loop gang vector
		for (i=0; i < n; ++i) {
			z[i] = x[i] + y[i];
		}
	}

}



// arrays initialisieren und erstellen
