import numpy as np
import matplotlib.pyplot as plt

def BFGS(func,gradient,startp,startm):

    k = 0
    x = startp
    A = startm
    # Pruefe Abbruchkriterien
    if(not np.any(gradient(x)) or k > 1000 ):
        return 1
    # Berechne BFGS-Update

    return 2;


def quadratic_func(x):
    Q = np.array([[2,0], [0,1]])
    q = np.array([[-4],[-2]])
    c = 3
    res = float(((x.T).dot(Q).dot(x))+ (q.T).dot(x)+c)
    return res;

def grad (x):
    Q = np.array([[2,0], [0,1]])
    q = np.array([[-4], [-2]])

    res = 2*Q.dot(x)+q
    return res;


def main():

    startp = np.array([[5],[-5]],dtype=np.float)
    startm = np.array([[1,0],[0,1]])

    print(BFGS(quadratic_func,grad,startp,startm))


if __name__ == '__main__':
    main()
