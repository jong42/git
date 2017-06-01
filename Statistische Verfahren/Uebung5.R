#### Set up working directory and import data
dir = "C:/Users/xi86xev/Desktop/git/Statistische Verfahren"
file_name = "mietspiegel99.csv"
setwd(dir)
d = read.csv(file_name)

#### Calculate Maximum Likelihood Predictor
# by hand
x = cbind(1, 1/d$flaeche) 
beta_hat=solve(a=t(x)%*%x,b=t(x)%*%d$mieteqm)
beta_hat

# with lm-function
fit = lm(mieteqm ~ 1+I(1/flaeche),d)
fit$coefficients[1]
fit$coefficients[2]

### Add new parameter "lage"
d$f_lage = factor(d$lage)
fit2 = lm(mieteqm ~ 1+I(1/flaeche)+f_lage,d)
summary(fit2)

fit2$coefficients[3]
fit2$coefficients[4]

###Zusatz
fit2.5 = lm(mieteqm ~ 1+I(1/flaeche)+f_lage+I(1/flaeche):f_lage,d)
summary(fit2.5)

### Display relation between "Baujahr" and "Quadratmeterpreis" 
plot(d$bjahr,d$mieteqm)
fit3 = lm(mieteqm ~ 1+I(1/flaeche)+f_lage+bjahr**2,d)
summary(fit3)
fit3$coefficients[5]

###Korrektur
fit3.5 = lm(mieteqm ~ 1+I(1/flaeche)+f_lage+I(1/flaeche):f_lage+bjahr+bjahr**2,d)
summary(fit3.5)

### Add further parameters
fit4 = lm(mieteqm ~ 1+I(1/flaeche)+f_lage+bjahr**2+bad+kueche+zh,d)
summary(fit4)
fit4$coefficients[6]
fit4$coefficients[7]
fit4$coefficients[8]

### plot residuals of models

# residual plots
par(mfrow=c(2,2))
plot (resid(fit))
plot (resid(fit2))
plot (resid(fit3))
plot (resid(fit4))

# histograms with normal distribution
width = seq(-15,15,0.1)

hwidth = dnorm(width,mean(fit$residuals),sigma(fit))
hist (resid(fit),freq=FALSE)
lines(width,hwidth,type="l",col="red",lwd=3)
hwidth = dnorm(width,mean(fit2$residuals),sigma(fit2))
hist (resid(fit2),freq=FALSE)
lines(width,hwidth,type="l",col="red",lwd=3)
hwidth = dnorm(width,mean(fit3$residuals),sigma(fit3))
hist (resid(fit3),freq=FALSE)
lines(width,hwidth,type="l",col="red",lwd=3)
hwidth = dnorm(width,mean(fit4$residuals),sigma(fit4))
hist (resid(fit4),freq=FALSE)
lines(width,hwidth,type="l",col="red",lwd=3)

rm(width)
rm(hwidth)

### Calculate estimated and adjusted variance

n = dim(d)[1]
y = d$mieteqm


x = cbind(1, 1/d$flaeche)
k = 1
beta_hat = solve(a=t(x)%*%x,b=t(x)%*%d$mieteqm)
sigma_hat_1 = (1/n)* t(y-(x %*% beta_hat)) %*% (y-x%*%beta_hat)
sigma_snake_1 = n/(n-(k+1))*sigma_hat_1

x = cbind(1, 1/d$flaeche,d$f_lage)
k = 3
beta_hat = solve(a=t(x)%*%x,b=t(x)%*%d$mieteqm)
sigma_hat_2 = (1/n)* t(y-(x %*% beta_hat)) %*% (y-x%*%beta_hat)
sigma_snake_2 = n/(n-(k+1))*sigma_hat_2

x = cbind(1, 1/d$flaeche,d$f_lage,d$bjahr)
k = 4
beta_hat = solve(a=t(x)%*%x,b=t(x)%*%d$mieteqm)
sigma_hat_3 = (1/n)* t(y-(x %*% beta_hat)) %*% (y-x%*%beta_hat)
sigma_snake_3 = n/(n-(k+1))*sigma_hat_3

x = cbind(1, 1/d$flaeche,d$f_lage,d$bjahr,d$bad,d$kueche,d$zh)
k = 7
beta_hat = solve(a=t(x)%*%x,b=t(x)%*%d$mieteqm)
sigma_hat_4 = (1/n)* t(y-(x %*% beta_hat)) %*% (y-x%*%beta_hat)
sigma_snake_4 = n/(n-(k+1))*sigma_hat_4

### Ortsübliche Vergleichsmiete
flaeche = 100
bjahr = 1950
f_lage = factor(3)
bad = 1
kueche = 0
zh = 1
d_new = data.frame(flaeche,bjahr,f_lage,bad,kueche,zh)
predict(fit,d_new)
predict(fit2,d_new)
predict(fit3,d_new)
predict(fit4,d_new)

predict(fit2.5,d_new)
predict(fit3.5,d_new)

######################Aufgabe 2

#### Set up working directory and import data
#dir = "C:/Users/xi86xev/Desktop/git/Statistische Verfahren"
#file_name = "bloodpressure.csv"
#setwd(dir)
#d = read.csv(file_name,sep = ";")

### ML-Estimations for model
#fit = lm(bp ~ 1+age,d)
#summary(fit)$coefficients

###
