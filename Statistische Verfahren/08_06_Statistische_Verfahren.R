setwd("C:/Users/xi86xev/Desktop/git/Statistische Verfahren")
blood.data = read.csv("bloodpressure.csv", sep=";")
head(blood.data)

plot(bp~age, data=blood.data)

X = cbind(1,blood.data$age)
y = blood.data$bp

beta.hat = solve(t(X) %*% X) %*% t(X) %*% y
beta.hat
abline(beta.hat)

fitted.values = X %*% beta.hat
residuen = y-fitted.values
plot(fitted.values, residuen)
abline(h=0, lty=2)

blood.lm = lm(bp~1+age, data=blood.data)
coef(blood.lm)

sigma2.hat = sum(residuen^2)/(54-2)
var.hat = diag(sigma2.hat * (diag(54)-X %*% solve (t(X) %*% X) %*% t(X)))

plot(blood.lm, which=1)
plot(blood.lm, which=3)

std.residuals = residuen/sd(residuen)
points(fitted.values,sqrt(abs(std.residuals)),pch=16, col=3)

## ML-Schätzer für varianzheterogenes Modell

beta.hat2 = solve(t(X) %*% v %*% X) %*% t(X) %*% v %*% y

## Schätzung der Matrix V

age.group = cut(blood.data$age, breaks = seq(19,59,5))
vars = tapply(blood.data$bp, age.group, var)
v = diag(1/vars[match(age.group, names(vars))])

ki = predict(blood.lm, newdata=data.frame(age=20:60), interval= "confidence")

points(20:60, ki[,2], type="l", col=2)
points(20:60, ki[,3], type="l", col=2)
