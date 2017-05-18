setwd("C:/Users/xi86xev/Desktop/git/Statistische Verfahren")
d = read.csv("2017_SS_7_2_3_mietspiegel99.csv")

# design-matrix
x = cbind(1,d$flaeche)

# Zielgröße
y = d$miete

# ML-Schätzer bestimmen
beta_hat = solve(t(x) %*% x) %*% t(x) %*% y

plot (d$flaeche, d$miete, pch=16, cex=0.8)
abline(beta_hat, col=2,lwd=2)


model = lm(1+miete~flaeche,d)
# ist in R das selbe wie
model = lm(miete~flaeche,d)

model = lm(miete~-1+flaeche,d)

plot (d$flaeche, d$miete, pch=16, cex=0.8, xlim=c(0,160), ylim=c(0,3500))
abline(beta_hat, col=2,lwd=2)
abline(c(0,12.87), col=3,lwd=2)

# Residuenvektor

e = y - x %*% beta_hat
e1 = residuals(model)

# Residuendarstellung

plot(d$flaeche,e1)

# keine sinnvolle Darstellung
plot(d$miete,e1)

y_hat = x%*% beta_hat
plot(y_hat,e1)

# Residuendarstellung weist auf ungenügende Annahmen hin: 
# Entweder Modell oder Parameter ändern

# Parameter Lage wird hinzugenommen
model2 = lm(miete~1+flaeche+lage,d)

plot(d$flaeche, d$miete, pch=16,cex=0.8)
points(d$flaeche, predict(model2), pch="+", col=d$lage+1, cex=1)

# Macht erst mal keinen Sinn, weil Lage nur Werte 1,2 oder 3 hat, 
#deshalb wird Lage als Faktorvariable gekennzeichnet:

model3 = lm(miete~1+flaeche+as.factor(lage),d)

plot(d$flaeche, d$miete, pch=16,cex=0.8)
points(d$flaeche, predict(model3), pch="+", col=d$lage+1, cex=1)

# Designmatrix ausgeben
model.matrix(model3)


# flaeche:as.factor(lage) ist Wechselwirkungsterm: Wie beeinflusst eine EInflussgröße
# den Einfluss einer anderen EInflussgröße auf die Zielvariable 

model4 = lm(miete~1+flaeche+ as.factor(lage) + flaeche:as.factor(lage),d)
# ist das selbe wie
model4 = lm(miete~(1+flaeche) * (1+as.factor(lage)),d)

plot(d$flaeche, d$miete, pch=16,cex=0.8)
points(d$flaeche, predict(model4), pch="+", col=d$lage+1, cex=1)

plot(model4,which=1, col=d$lage+1, pch=16, cex=0.5)
# immer noch keine gleichmäßige Variabilität. 
# Als nächstes wird eine nicht gleiche Varianz pro Beobachtung angenommen