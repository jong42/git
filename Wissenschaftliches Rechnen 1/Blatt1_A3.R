library(Matrix)

################################################
##### Erstellen des Gleichungssystems Ax=b
################################################

create_band_matrix = function(h){
  main_diag = seq(4,4,length.out = 1/h**2)
  side_diag = seq(-1,-1,length.out = 1/h**2)
  A_tridiag = bandSparse(n=as.integer(1/h**2)+1,m=as.integer(1/h**2)+1,k=c(-1,0,1,1/h,-1/h), diagonals=list(side_diag,main_diag,side_diag,side_diag,side_diag))
  return (A_tridiag)
}

create_b_vector = function(h){
  b = vector(length = 1/h**2)
  for(x in seq(0.1,1,by=h)){
    for (y in seq(0.1,1,by=h)){
      b[x/h**2 + y/h] = x*(1-x)+y*(1-y)
    }
  }
  return(b[-(1:9)])
}

A = create_band_matrix(0.1)
b = create_b_vector(0.1)

################################################
##### LU-Faktorisierung
################################################
h = 0.1


perform_LU_fact = function(h,A) {
# Perform LR-Partitioning
  n = 100
  R = A
  L = diag(1,n,n)

  # n-1 Iterationsschritte
  for (i in seq(1,n-1)) {
    print(paste0("Step: ", i))
    for(k in seq(i+1,n)) {
      print(k)
      # Berechnung von L
      L[k,i] = R[k,i] / R[i,i]
      #print(L)
      # Spalten der Restmatrix werden durchlaufen
      for (j in seq(i,n)) {
        #Berechnung von R
        
        R[k,j] = R[k,j] - L[k,i] * R[i,j]
        #print(R)
      } 
    }
  }
  return (list("L" = L,"R" = R))
}

res = perform_LU_fact(h,A)
L = res[[1]]
R = res[[2]]

################################################
##### Löse Ly = b
################################################

y = solve(L,b)

################################################
##### Löse Rx = y
################################################

x = solve(R,y)
