import numpy as np
import matplotlib.pyplot as plt

def newtonverfahren_damped(func,gradient,epsilon,hessematrix,delta,beta):
	# Setze Startpunkt und Zaehler
	k = 0
	finish = False
	x = np.array([[1],[1]])
	while (finish == False):
		# Pruefe, ob Minimum bereits erreicht ist
		if (not np.any(gradient(x))):
			break
		# Pruefe, ob Abbruchkriterium bereits erfuellt ist
		if (np.linalg.norm(gradient(x))<epsilon):
			break
		# Fuege zusaetzliche Abbruchkriterien hinzu
		if (k>1000):
			break
		# Berechne Armijo-Schrittweite
		d = - gradient(x)
		sigma = 1
		finish_2 = False
		while (finish_2 == False):
        	# Pruefe, ob Bedingung erfuellt ist
			x_new = x+sigma*d
			if(func(x_new) <= func(x)+(delta*sigma*(gradient(x).T)).dot(d)):
				break
			sigma = beta*sigma
		# Berechne naechsten Versuchs-Punkt
		x = x + sigma*d
		# inkrementiere Zaehlvariable
		k+=1

	#print("k:"+str(k))
	return x;

def quadratic_func(x):
	Q = np.array([[1,2], [2,1]])
	q = np.array([[2],[2]])
	c = 2
	res = 0.5* float(((x.T).dot(Q).dot(x))+ (q.T).dot(x)+c)
	return res;

def gradient(x):
	Q = np.array([[1,2], [2,1]])
	q = np.array([[2],[2]])
	res = Q.dot(x)+q
	return res;

def hessematrix(x):
    Q = np.array([[1,2], [2,1]])
	res = Q
	return res;

def main():


	epsilon = 0.01
	delta = 0.01
	beta = 0.5

	print (newtonverfahren_damped(quadratic_func,gradient,epsilon, delta, beta))


if __name__ == '__main__':
    main()



