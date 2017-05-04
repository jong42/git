theta = 2
n = 20

set.seed(1)
y =  rexp(n,theta)
hist(y)

likelihood = function(theta)
{
  prod(theta*exp(-theta*y))
}

theta.seq = seq(0.1,5,0.01)


# Für theta wird die Funktion nun komponentenweise ausgewertet:
likelihood.vec = Vectorize(likelihood, "theta")

likelihood.vec(theta.seq)
plot(theta.seq, likelihood.vec(theta.seq), type="l")

loglikelihood = function(theta)
{
  n= length(y)
  return (n*log(theta)-theta*sum(y))
}

loglikelihood.vec = Vectorize(loglikelihood, "theta")
plot(theta.seq, loglikelihood.vec(theta.seq), type="l")

score = function(theta)
{
  n = length(y)
  return((n/theta)-sum(y))
}

score.vec = Vectorize(score, "theta")
plot(theta.seq, score.vec(theta.seq), type="l")

abline(h=0, lty=2)

theta.hat = length(y)/sum(y)

abline(v=theta.hat, lty=2)

simanz = 10
theta.hat = rep(0,simanz)
for (i in 1:simanz)
{
  ### Simulation von Pseudobeobachtungen
  y = rexp(n,theta)
  
  ### Darstellung der Scorefunktion
  points(theta.seq,score.vec(theta.seq), type="l", col=i)
  
  ### Maximum-Likelihood-Schätzung
  theta.hat[i] = n/sum(y)
  abline(v=theta.hat[i], col = i)
}

var(theta.hat)

### beobachtete und erwartete Fisher-Information
