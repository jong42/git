library(ggplot2)

########################
#### 1.
#########################

# Simulieren der Zufallsstichprobe
n = 20
theta = 2
sample = rexp(n,theta) 

# Aufstellen der Likelihoodfunktion
likelihood = function(theta_par) {
  prod(dexp(sample,rate=theta_par,log=F))
}

theta_seq = seq(0,5)
for (i in theta_seq)
{
like[i] = likelihood(theta_seq[i])
}
plot(x=seq(0,4),y=like, type="l", main="likelihood function")





