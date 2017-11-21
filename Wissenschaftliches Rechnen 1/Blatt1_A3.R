library(Matrix)

## x and y have to be between 0 and 1, h<=1
create_band_matrix = function(h){
  main_diag = seq(4,4,length.out = 1/h**2)
  side_diag = seq(-1,-1,length.out = 1/h**2)
  A_tridiag = bandSparse(n=as.integer(1/h**2),m=as.integer(1/h**2),k=c(-1,0,1,1/h,-1/h), diagonals=list(side_diag,main_diag,side_diag,side_diag,side_diag))
  return (A_tridiag)
}


A = create_band_matrix(0.1)

laplace_operator = - (x*(1-x)+y*(1-y))
u_rand = 0