# Zufallszahlengenerator wird initialisiert
set.seed(13) 

# Zufallszahl wird ausgegeben
runif(10000)

# normalverteilte Zufallszahlen
z = rnorm(10000)
hist(z,freq=F)


x = seq (-4,4,0.01)
points(x,dnorm(x),type="l",col=2)

# Verteilungsfunktion F(t) = P(Z <= t)
plot(x, pnorm(x), type="l")
