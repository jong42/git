# Initialize A,L and R

R_org = matrix(c(1,2,3,4,0,5,6,7,0,0,8,9,0,0,0,10),nrow=4,ncol=4,byrow=TRUE)
L_org = matrix(c(1,0,0,0,5,1,0,0,4,8,1,0,9,5,8,1),nrow=4,ncol=4,byrow=TRUE)
A = L_org%*%R_org

# Size of matrix
n = 4

# Perform LR-Partitioning
R = A
L = matrix(c(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1),nrow=4,ncol=4,byrow=TRUE)

# n-1 Iterationsschritte
for (i in seq(1,n-1)) {
  print(paste0("Step: ", i))
  for(k in seq(i+1,n)) {
    # Berechnung von L
    L[k,i] = R[k,i] / R[i,i]
    print(L)
    # Spalten der Restmatrix werden durchlaufen
    for (j in seq(i,n)) {
      #Berechnung von R
      R[k,j] = R[k,j] - L[k,i] * R[i,j]
      print(R)
    } 
  }
}

