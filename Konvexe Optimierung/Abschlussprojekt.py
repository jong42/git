import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import minimize
import math

def gradientenverfahren(c,y,x,grad,start,tolx,tolg):
	# Setze Startpunkt und Z?hler
	k = 0
	finish = False
	z_old = start
	while (finish == False):
		# Berechne Gradient
		gradient = grad(z_old,c,y,x)
		# Berechne Abstiegsrichtung
		d = - gradient
		# Bestimme Schrittweite
		sigma = 1/(k+1)
		# Berechne n?chsten Versuchs-Punkt
		z_new = z_old + sigma *d
		#Pruefe, ob Minimum bereits erreicht ist
		if (not np.any(gradient)):
			finish = False
			break
		# F?ge zus?tzliche Abbruchkriterien hinzu
		if (np.linalg.norm(gradient,ord=2)<=tolg):
		        finish = False
		        break
                if(np.linalg.norm(z_new-z_old, ord=2)<=tolx):
		        finish = False
		        break
		if (k>100000):
			finish = False
			break
		# inkrementiere Z?hlvariable
		k+=1
		z_old = z_new

	return z_new;

def subgradientenverfahren(c,y,x,subgrad,start,tolx,tolg):
    k = 0
    wb_old = start
    while k<1000:
        ## Waehle Subgradient aus
        s = grad_linfunc(wb_old,c,y,x)
        # Bestimme Schrittweite, Richtung und neuen Startwert
        d = -(s/np.linalg.norm(s,ord=2))
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

def newtonverfahren(func,gradient,epsilon,hessematrix,delta,beta):
	# Setze Startpunkt und Zaehler
	k = 0
	finish = False
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

def logfunc(z,c,y,x):
    interim_res = 0
    A = np.array([[1,0,0],[0,1,0],[0,0,0]])
    for i in range(0, len(x.T)):
        interim_res += log(1+ math.exp(-y[i]*np.array([x.T[i]]).dot(z)))
    res = 0.5 * (z.T).dot(A.dot(z)) + c * interim_res
    return res

def grad_quadfunc(z,c,y,x):
    def h(z,i,x,y):
        h_res = 2*max(0,1-y[i]*np.array([x.T[i]]).dot(z))
        return h_res
    def g(z,i,x,y):
        g_res = -y[i]*np.array([x.T[i]]).T
        return g_res
    A = np.array([[1,0,0],[0,1,0],[0,0,0]])
    res = A.dot(z) +c*sum([h(z,i,x,y)*g(z,i,x,y) for i in range(0,len(x[1]))])
    return res
    
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

def grad_logfunc(z,c,y,x):
  
  def h(z,i,x,y):
    res_h= ((1+math.exp(-y[i]*np.array([x.T[i]]).dot(z)))**-1)
    return res_h
  
  def g(z,i,x,y):
    res_g= math.exp(-y[i]*np.array([x.T[i]]).dot(z))
    return res_g
  
  A = np.array([[1,0,0],[0,1,0],[0,0,0]])
  res = A.dot(z) +c*sum([h(z,i,x,y)*g(z,i,x,y)*(-y[i])*np.array([x.T[i]]).T for i in range(0,len(x[1]))])
  return res

def hessemat_logfunc(z,c,x,y):
  A = np.array([[1,0,0],[0,1,0],[0,0,0]])
  h = -((1+math.exp(-y[i]*np.array([x.T[i]]).dot(z)))**-2) * (exp(-y[i]*np.array([x.T[i]]).dot(z)))**2 * (y[i]*np.array([x.T[i]]).T)
  g = exp(-y[i]*np.array([x.T[i]]).dot(z))* ((-y[i])*np.array([x.T[i]]).T)
  res = A + c * sum([(-y[i]*np.array([x.T[i]]).T).T * (h+g)  for i in range(0,len(x[1]))])
  return res

def main():
    ## Trainingspunkte erstellen
    
    x1 = np.array([-1,-1,-3,-2,-4, 4, 1, 3, 6, 2])
    x2 = np.array([ 1, 3, 4, 2, 1,-1,-6,-3,-3,-1])
    y  = np.array([ 1, 1, 1, 1, 1,-1,-1,-1,-1,-1])
    
    plt.plot(x1[0:5],x2[0:5],'ro')
    plt.plot(x1[5:10],x2[5:10],'bo')
    
    ## Parameter einstellen
    tolx = 0.01
    tolg = 0.01
    c = 1
    start = np.zeros(3).reshape(3,1)
    #start = np.array([1,1,1]).reshape(3,1)
    #start = np.array([5,5,5]).reshape(3,1)
    
    ## Vektorisieren
    x_offset = np.ones(len(x1)) 
    x = np.array([x1,x2,x_offset])
    
    ## Linearer Fehler
    ret_lin = subgradientenverfahren(c,y,x,grad_linfunc,start,tolx,tolg)
    w = np.array([ret_lin[0],ret_lin[1]])
    b = ret_lin[2]
    #print(ret_lin)
    t = np.arange(-5, 5, 1)
    plt.plot(t,-w[0]/w[1]*t-b/w[1],'g',label='Subgradientenverfahren')
    

    ## Quadratischer Fehler
    ret_quad = gradientenverfahren(c,y,x,grad_quadfunc,start,tolx,tolg)
    w = np.array([ret_quad[0],ret_quad[1]])
    b = ret_quad[2]
    #print(ret_quad)
    t = np.arange(-5, 5, 1)
    plt.plot(t,-w[0]/w[1]*t-b/w[1],'r',label='Gradientenverfahren')
    plt.legend(loc=0)
    
    ## Logistischer Fehler
    print(hessemat_logfunc(start,c,x,y))
    #print(grad_logfunc(start,c,y,x))
    #print(grad_quadfunc(start,c,y,x))
    #plt.show()

if __name__ == '__main__':
    main()
