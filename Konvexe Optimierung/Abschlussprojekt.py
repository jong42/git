import numpy as np
import matplotlib.pyplot as plt

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

def subgradientenverfahren_betragsfkt(start,tolx,tolg):
    k = 0
    x_old = start

    while k<10000:
        ## Waehle Subgradient aus
        if (-x_old > x_old):
            s = g1(x_old)
        elif (x_old > -x_old):
            s = g2(x_old)
        else:
            #beliebige Linearkombination aus g1 und g2: 1*g1+0*g2
            s = g1(x_old)
        # Bestimme Schrittweite, Richtung und neues x
        d = -(s/np.linalg.norm(s,ord=2))
        #sigma = float(1/(k+1)) konvergiert nicht richtig...
        sigma = 0.01
        x_new = x_old+sigma*d
        # Pruefe Abbruchkriterien
        if(np.linalg.norm(x_new-x_old, ord=2)<=tolx):
            return x_new
        elif (s<=tolg):
            return x_new
        # Vorbereitung fuer naechsten Durchlauf
        k += 1
        x_old = x_new
        #print(x_new)

    return x_new;

def subgradientenverfahren(start,tolx,tolg):
    k = 0
    x_old = start
    
    def g1(x,y,w,b):
		res = max(0,1-y(wx+b))
		return res

    while k<10000:
        ## Waehle Subgradient aus
        if (-x_old > x_old):
            s = g1(x_old)
        elif (x_old > -x_old):
            s = g2(x_old)
        else:
            #beliebige Linearkombination aus g1 und g2: 1*g1+0*g2
            s = g1(x_old)
        # Bestimme Schrittweite, Richtung und neues x
        d = -(s/np.linalg.norm(s,ord=2))
        #sigma = float(1/(k+1)) konvergiert nicht richtig...
        sigma = 0.01
        x_new = x_old+sigma*d
        # Pruefe Abbruchkriterien
        if(np.linalg.norm(x_new-x_old, ord=2)<=tolx):
            return x_new
        elif (s<=tolg):
            return x_new
        # Vorbereitung fuer naechsten Durchlauf
        k += 1
        x_old = x_new
        #print(x_new)

    return x_new;

def main():
    ## Trainingspunkte erstellen
    
    x_lab1 = [-1,-1,-3,-2,-4]
    y_lab1 = [1,3,4,2,1]
    x_lab2 = [4,1,3,6,2]
    y_lab2 = [-1,-6,-3,-3,-1]
    
    plt.plot(x_lab1,y_lab1,'ro')
    plt.plot(x_lab2,y_lab2,'bo')

    plt.show()

    ## Linearer Fehler


if __name__ == '__main__':
    main()
