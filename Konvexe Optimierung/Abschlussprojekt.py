import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import minimize

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
		# F?ge zus?tzliche Abbruchkriterien hinzu
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

def subgradientenverfahren(c,y,x,subgrad,start,tolx,tolg):
    k = 0
    wb_old = start
    while k<1000:
        ## Waehle Subgradient aus
        s = grad_linfunc(wb_old,c,y,x)
        # Bestimme Schrittweite, Richtung und neuen Startwert
        d = -(s/np.linalg.norm(s,ord=2))
        #
        sigma = 1/np.sqrt(1+k)
        wb_new = wb_old+sigma*d
        # Pruefe Abbruchkriterien
        if(np.linalg.norm(wb_new-wb_old, ord=2)<=tolx):
            return wb_new
        elif (np.linalg.norm(s,ord=2)<=tolg):
            return wb_new
        # Vorbereitung fuer naechsten Durchlauf
        k += 1
        wb_old = wb_new
        #print(x_new)

    return wb_new;

def linfunc(z,c,y,x):
    interim_res = 0
    A = np.array([[1,0,0],[0,1,0],[0,0,0]])
    for i in range(0, len(x.T)):
        interim_res += max(0,1-y[i]*np.array([x.T[i]]).dot(z))
    res = 0.5 * (z.T).dot(A.dot(z)) + c * interim_res
    return res
    
def quadfunc(z,c,y,x):
    interim_res = 0
    A = np.array([[1,0,0],[0,1,0],[0,0,0]])
    for i in range(0, len(x.T)):
        interim_res += (max(0,1-y[i]*np.array([x.T[i]]).dot(z)))**2
    res = 0.5 * (z.T).dot(A.dot(z)) + c * interim_res
    return res

##def grad_quadfunc(z,c,y,x):
##    def h(z,i,x,y):
##        2*max(0,1-y[i]*np.array([x.T[i]]).dot(z))
##        return res
##    A = np.array([[1,0,0],[0,1,0],[0,0,0]])
##    res = A.dot(z) +c*sum([h(z,i,x,y) for i in range(0,len(x[1]))])
##    return res
    
def grad_linfunc(z,c,y,x):
    
    def g(z,i,x,y):
        res = 1-y[i]*np.array([x.T[i]]).dot(z)
        return res
    
    def h(z,i,x,y):
        g_res = g(z,i,x,y)
        if (g_res>0):
            res = -y[i]*np.array([x.T[i]]).T
        elif (g_res==0):
			## beliebige Konvexkombination beider Gradienten
            res = -y[i]*np.array([x.T[i]]).T
        else:
            res = np.zeros(3).reshape(3,1)
        
        return res
    
    A = np.array([[1,0,0],[0,1,0],[0,0,0]])
    
    res = A.dot(z) +c*sum([h(z,i,x,y) for i in range(0,len(x[1]))])
    return res


def main():
    ## Trainingspunkte erstellen
    
    x1 = np.array([-1,-1,-3,-2,-4, 4, 1, 3, 6, 2])
    x2 = np.array([ 1, 3, 4, 2, 1,-1,-6,-3,-3,-1])
    y  = np.array([ 1, 1, 1, 1, 1,-1,-1,-1,-1,-1])
    
    plt.plot(x1[0:5],x2[0:5],'ro')
    plt.plot(x1[5:10],x2[5:10],'bo')
    
    tolx = 0.01
    tolg = 0.01
    
    ## Linearer Fehler
    c = 1
    x_offset = np.ones(len(x1)) 
    x = np.array([x1,x2,x_offset])
    start = np.zeros(3).reshape(3,1)
    ret = subgradientenverfahren(c,y,x,grad_linfunc,start,tolx,tolg)
    w = np.array([ret[0],ret[1]])
    b = ret[2]
    #print(ret)
    t = np.arange(-5, 5, 1)
    plt.plot(t,-w[0]/w[1]*t-b/w[1],'g')
    plt.show()

    ## Quadratischer Fehler
    

if __name__ == '__main__':
    main()
