import numpy as np

def gradientenverfahren(Q,q,c):
	# Setze Startpunkt und Z?hler
	k = 0
	finish = False
	x = 1
	while (finish == False):
		# Berechne Gradient
		gradient = Q.dot(x)+q
		# Pr?fe, ob Minimum bereits erreicht ist
		if (not np.any(gradient)):
			finish = False
			break
		# F?ge zus?tzliche Abbruchriterien hinzu
		if (k>100000):
			finish = False
			break
		# Berechne exakte Schrittweite
		d = - gradient
		sigma = ((d.T)*d)/(((d.T).dot(Q)).dot(d))
		# Berechne n?chsten Versuchs-Punkt
		x = x + sigma.dot(d)
		# inkrementiere Z?hlvariable
		k+=1

	return x;

def cgmethode(Q,q,c):
    # Setze Startpunkt und Z?hler
	k = 0
	finish = False
	x = 1
	# Bestimme erste Abstiegsrichtung
	d = - (Q.dot(x)+q)
    	while (finish == False):
		# Berechne Gradient
		gradient = Q.dot(x)+q
		# Pr?fe, ob Minimum bereits erreicht ist
		if (not np.any(gradient)):
			finish = False
			break
		# F?ge zus?tzliche Abbruchriterien hinzu
		if (k>100000):
			finish = False
			break
		# Berechne exakte Schrittweite
		d = - gradient
		sigma = ((d.T)*d)/(((d.T).dot(Q)).dot(d))
		# Berechne n?chsten Versuchs-Punkt
		x = x + sigma.dot(d)
		# Berechne Gradienten f?r n?chsten Versuchspunkt
		gradient_next = Q.dot(x)+1
		# Berechne beta
		beta = gradient_next / gradient
		# Berechne neue Abstiegsrichtung
		d = - gradient_next + beta.dot(d)
		# inkrementiere Z?hlvariable
		k+=1

	return x;

def main():

	Q = np.array([[1,2,3], [4,5,6], [7,8,9]])
	q = np.array([1,2,1])
	print (gradientenverfahren(Q,q,1))
 	print (cgmethode(Q,q,1))

if __name__ == '__main__':
    main()



