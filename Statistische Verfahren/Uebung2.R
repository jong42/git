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
var = (0.5)^2

### k=5
k = 5


y = sum(runif(k))/k
for (i in 1:999) {
  new_element = sum(runif(k))/k
  y = c(y,new_element)}

hist(y)
plot(y,dnorm(y,E,var))
distribution = ecdf(y)


### k=10
k = 10

y = sum(runif(k))/k
for (i in 1:999) {
  new_element = sum(runif(k))/k
  y = c(y,new_element)}

hist(y)
plot(y,dnorm(y,E,var))
distribution = ecdf(y)




########################
### 3.
########################

d = read.csv("/home/xi86xev/git/git/Statistische Verfahren/2017_SS_7_2_3_soilrespiration1.csv", sep = ";")



  
