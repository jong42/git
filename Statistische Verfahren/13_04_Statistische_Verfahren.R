# vektoren
temperature = c(7.5,8.4,9.0,1,7,11.8,11.9,12,8)
resp = c(122,176,102,162,288,182,196,218,148)
logresp = log(resp)

plot(temperature, logresp)
plot (temperature,resp)

# vektoren mit Struktur
2:10
-3:5
seq(3,6,0.5)


# matrizen
mat = matrix (1:12,3,4)

cbind (temperature,resp)
rbind (temperature,resp)

# Alle Einträge einer Matrix müssen den gleichen Typ haben. Deswegen dataframe oft besser geeignet

# dataframe
d =data.frame(temperature,resp)
d$resp
d[1:4,1]

# Gittersuche nach bester Geraden

beta0.seq = seq(0.1,5,0.01)
beta1.seq = seq(0.1,0.25,0.01)

# abline legt eine Linie durch den plot
abline(4.6,0.1)

resultmatrix= matrix(0,length(beta0.seq), length(beta1.seq))

for (i in 1:length(beta0.seq))
{
  for (j in 1: length(beta1.seq))
  {
  
    beta0 = beta0.seq[i]
    beta1 = beta1.seq[j]
    
    resultmatrix[i,j] = sum ((logresp-(beta0 + beta1 + temperature))^2)
  }
  
}

min (resultmatrix)

head (resultmatrix)

which (resultmatrix==min(resultmatrix), arr.ind = T)

beta0best = beta0.seq[1]
beta1best = beta1.seq[1]

#???
abline (beta1best,beta0best) 

