########################
#### 1.
#########################
mu = 5
sigma_squared = 2
sigma = sqrt(sigma_squared)

# P(mu-sigma <= Y <= mu + sigma)
pnorm(mu+sigma,mu, sigma) - pnorm(mu-sigma,mu, sigma)

# P(mu-2sigma <= Y <= mu + 2sigma)
pnorm(mu+2*sigma,mu, sigma) - pnorm(mu-2*sigma,mu, sigma)

# P(mu-3*sigma <= Y <= mu + 3*sigma)
pnorm(mu+3*sigma,mu, sigma) - pnorm(mu-3*sigma,mu, sigma)

########################
### 2.
########################
library(stats)


E = 0.5
var = (0.5)^2  ###richtig: var = 1/(12k)

### k=5
k = 5


y = sum(runif(k))/k
for (i in 1:999) {
  new_element = sum(runif(k))/k
  y = c(y,new_element)}


hist(y, freq=F)

### Vergleich mit Normalverteilung:
z = seq(0,1,0.01)
points(z, dnorm(z, mean= 1/2, sd=sqrt(1/(12*k))), type="l")

plot (ecdf(y))
points(z, pnorm(z, mean= 1/2, sd=sqrt(1/(12*k))), type="l", col=2)

### k=10
k = 10

y = sum(runif(k))/k
for (i in 1:999) {
  new_element = sum(runif(k))/k
  y = c(y,new_element)}

z = seq(0,1,0.01)
points(z, dnorm(z, mean= 1/2, sd=sqrt(1/(12*k))), type="l")

plot (ecdf(y))
points(z, pnorm(z, mean= 1/2, sd=sqrt(1/(12*k))), type="l", col=2)




########################
### 3.
########################

beta0 = 4.3
beta1 = 0.075
sigma2 = 0.07

d = read.csv("C:/Users/xi86xev/Desktop/git/Statistische Verfahren/2017_SS_7_2_3_soilrespiration1.csv", sep = ";")

x = d$temp
y = log(d$resp)

plot (x,y, pch=16, col=1)

set.seed(13)  
y.sim = rnorm(76,mean=beta0+beta1*x, sd=sqrt(sigma2))

points(x,y.sim, pch = 16, col=2)


