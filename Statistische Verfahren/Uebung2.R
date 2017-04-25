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

E = 0.5
var = (0.5)^2

k = 5

y = (1/k)*
runif()

########################
### 3.
########################

x = read.csv()


  
