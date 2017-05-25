import numpy as np

def gradientenverfahren_armijo(Q,q,epsilon,delta, beta):
	# Setze Startpunkt und Z?hler
	k = 0
	finish = False
	x = np.array([[1],[1]])
	while (finish == False):
		# Berechne Gradient
		gradient = (Q.dot(x))+q
		#print (gradient)
		# Pr?fe, ob Minimum bereits erreicht ist
		if (not np.any(gradient)):
			break
		# Pr?fe, ob Abbruchkriterium bereits erf?llt ist
		if (np.linalg.norm(gradient)<epsilon):
			break
		# F?ge zus?tzliche Abbruchkriterien hinzu
		if (k>10000):
			break
		# Berechne Armijo-Schrittweite
		d = - gradient
		sigma = 1
		finish_2 = False
		while (finish_2 == False):
        	# Pr?fe, ob Bedingung erf?llt ist
			x_new = x+sigma*d
			# WAHRSCHEINLICH HIER EIN FEHLER: SCHLEIFE BRICHT NICHT AB
        	if(0.5*((x_new.T).dot(Q)).dot(x_new)+(q.T).dot(x_new) <= 0.5*((x.T).dot(Q)).dot(x)+(q.T).dot(x)+delta*sigma*gradient.T.dot(d)):
				break
        	sigma = beta*sigma
		# Berechne n?chsten Versuchs-Punkt
        x = x + sigma*d
		# inkrementiere Z?hlvariable
        k+=1

	print(k)
	return x;


def main():

	Q = np.array([[1,2], [2,1]])
	q = np.array([[2],[2]])
	epsilon = 0.001
	delta = 0.01
	beta = 0.5
	print (gradientenverfahren_armijo(Q,q,epsilon, delta, beta))


if __name__ == '__main__':
    main()



