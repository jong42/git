## Übungsblatt 1

##1.
d = read.csv("/home/xi86xev/git/git/Statistische Verfahren/2017_SS_7_2_3_soilrespiration1.csv", sep = ";")



plot(d[1],d[2])

# Gittersuche nach bester Geraden

beta0.seq = seq(0.1,5,0.01)
beta1.seq = seq(0.1,0.25,0.01)

temp = d$temp
resp = d$resp
logresp = log(resp)

plot(temp,log(resp))

resultmatrix= matrix(0,length(beta0.seq), length(beta1.seq))


for (i in 1:length(beta0.seq))
{
  for (j in 1: length(beta1.seq))
  {
    
    beta0 = beta0.seq[i]
    beta1 = beta1.seq[j]
    
    resultmatrix[i,j] = sum ((logresp-(beta0 + beta1 * temp))^2)
  }
  
}

bestfit = which (resultmatrix==min(resultmatrix), arr.ind = T)

beta0best = beta0.seq[369]
beta1best = beta1.seq[1]

abline (beta0best,beta1best, col="red")

##2.
n = 20
col1 = seq (from=1,to=1,length.out=20)
col2 = seq(1:n)

X = matrix(c(col1,col2),ncol=2)
beta = c(beta0,beta1)

# Vektor-Matrix-Multiplikation
X%*%beta
# Matrix-Matrix-Multiplikation
t(X)%*% X
# Inverse of matrix
solve(t(X)%*% X)

##3.

resultmatrix_abs= matrix(0,length(beta0.seq), length(beta1.seq))
resultmatrix_pot= matrix(0,length(beta0.seq), length(beta1.seq))
resultmatrix_ort= matrix(0,length(beta0.seq), length(beta1.seq))

# absolute differences

for (i in 1:length(beta0.seq))
{
  for (j in 1: length(beta1.seq))
  {
    
    beta0 = beta0.seq[i]
    beta1 = beta1.seq[j]
    
    resultmatrix_abs[i,j] = sum (abs(logresp-(beta0 + beta1*temp)))
  }
  
}

bestfit = which (resultmatrix_abs==min(resultmatrix_abs), arr.ind = T)

beta0best = beta0.seq[367]
beta1best = beta1.seq[1]

abline (beta0best,beta1best, col="yellow")

# 4. Potenz

for (i in 1:length(beta0.seq))
{
  for (j in 1: length(beta1.seq))
  {
    
    beta0 = beta0.seq[i]
    beta1 = beta1.seq[j]
    
    resultmatrix_pot[i,j] = sum ((logresp-(beta0 + beta1*temp))^4)
  }
  
}

bestfit = which (resultmatrix_pot==min(resultmatrix_pot), arr.ind = T)

beta0best = beta0.seq[371]
beta1best = beta1.seq[1]

abline (beta0best,beta1best, col="blue")

# orthogonale Abstände

for (i in 1:length(beta0.seq))
{
  for (j in 1: length(beta1.seq))
  {
    
    beta0 = beta0.seq[i]
    beta1 = beta1.seq[j]
    
    resultmatrix_ort[i,j] = sum ((logresp-(beta0 + beta1*temp))^4)
  }
  
}

bestfit = which (resultmatrix_ort==min(resultmatrix_ort), arr.ind = T)

beta0best = beta0.seq[371]
beta1best = beta1.seq[1]

abline (beta0best,beta1best, col="blue")
