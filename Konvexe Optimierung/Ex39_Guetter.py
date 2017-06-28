# coding=utf-8
import numpy as np

## Als zu minimierende Funktion wird die Betragsfunktion  y = |x| betrachtet

def subgradientenverfahren_betragsfkt(start,tolx,tolg):
    k = 0
    x_old = start

    while k<10000:
        ## Wähle Subgradient aus
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
        # Vorbereitung für nächsten Durchlauf
        k += 1
        x_old = x_new
        #print(x_new)

    return x_new


def g1(x):
    res = np.array([[-1]])
    return res

def g2(x):
    res = np.array([[1]])
    return res

def main():
    tolx = 0.0
    tolg = 0.0
    start = 3
    print(subgradientenverfahren_betragsfkt(start,tolx,tolg))


if __name__ == '__main__':
    main()

