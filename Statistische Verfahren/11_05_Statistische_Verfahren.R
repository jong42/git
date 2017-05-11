### Simulation ML-Schätzer Exponentialverteilung

n.seq = seq(10,200,10)
simanz = 1000
theta = 2

# simulationsschleife

theta.hat = matrix(0,simanz, length(n.seq))

for (i in 1:simanz)
{
  y = rexp(200, rate = 2)
  for (j in 1:length(n.seq))
  {
    theta.hat[i,j] = n.seq[j]/sum(y[1:n.seq[j]])
  }
  
}


bias = colMeans (theta.hat)-theta

plot(n.seq,bias, cex=2,pch=16, ylim=c(0,0.25))
abline(h=0, lty=2)

vars = apply(theta.hat,2,var)
plot (n.seq, vars, cex=2,pch=16)



