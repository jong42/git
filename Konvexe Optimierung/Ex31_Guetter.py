import numpy as np
import matplotlib.pyplot as plt

def newtonverfahren_damped(func,gradient,epsilon,hessematrix,delta,beta):
	# Setze Startpunkt und Zaehler
	k = 0
	finish = False
	#x = np.array([[1],[1]])
	x = np.array([[1]],dtype=np.float);
	while (finish == False):
		# Pruefe, ob Minimum bereits erreicht ist
		if (not np.any(gradient(x))):
			break
		# Pruefe, ob Abbruchkriterium bereits erfuellt ist
		if (np.linalg.norm(gradient(x))<epsilon):
			break
		# Pruefe, ob maximale Iterationszahl erreicht ist
		if (k>1000):
			break
		# Berechne Newton-Richtung
		d = np.linalg.solve(-hessematrix(x),gradient(x))
		# Berechne Armijo-Schrittweite
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

#def quadratic_func(x):
#	Q = np.array([[1,0], [0,1]])
#	q = np.array([[2],[2]])
#	c = 2
#	res = 0.5* float(((x.T).dot(Q).dot(x))+ (q.T).dot(x)+c)
#	return res;

#def gradient(x):
#	Q = np.array([[1,0], [0,1]])
#	q = np.array([[2],[2]])
#	res = Q.dot(x)+q
#	return res;

#def hessematrix(x):
#	Q = np.array([[1,0], [0,1]])
#	res = Q
#	return res;

def func2(x):
	res = 1+x**2
	return res;

def grad2(x):
	res = x / (np.sqrt(1+x**2))
	return res;

def hessemat2 (x):
	res = 1/ (np.sqrt(1+x**2)) - x**2/(np.sqrt(1+x**2)**3)
	return res;

def main():


	epsilon = 0.01
	delta = 0.01
	beta = 0.5

	#print (newtonverfahren_damped(quadratic_func,gradient,epsilon,hessematrix, delta, beta))
	print (newtonverfahren_damped(func2,grad2,epsilon,hessemat2, delta, beta))
	

if __name__ == '__main__':
    main()



