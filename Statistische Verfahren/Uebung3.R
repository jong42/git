
library(ggplot2)


########################
#### 1.
########################



### Simulieren der Zufallsstichprobe
n = 20
theta = 2
sample = rexp(n,theta) 
theta_seq = seq(0,5,0.01)

### Aufstellen und Plotten der Likelihoodfunktion
likelihood = function(theta_par) {
  prod(dexp(sample,rate=theta_par,log=F))
}

like=0
for (i in 1:length(theta_seq))
{
  like[i] = likelihood(theta_seq[i])
}
plot(x=theta_seq,y=like, type="l", main="likelihood function")


### Aufstellen und Plotten der Log-Likelihoodfunktion
log_likelihood = function(theta_par) {
  log(prod(dexp(sample,rate=theta_par)))
}

log_like=0
for (i in 1:length(theta_seq))
{
  log_like[i] = log_likelihood(theta_seq[i])
}
plot(x=theta_seq,y=log_like, type="l", main="Log-likelihood function")

# Aufstellen und Plotten der Score-Funktion

