#### Set up working directory and import data
dir = "C:/Users/xi86xev/Desktop/git/Statistische Verfahren"
file_name = "cities.csv"
setwd(dir)
d = read.csv(file_name)

cities.lm1 = lm(y ~ 1+ x1 + x2 + x3 + x4 +x5+x6, data=d)
cities.lm2 = lm(y ~ (1+ x1 + x2 + x3 + x4 +x5+x6)^2+I(x1^2)+I(x2^2)+I(x3^2)+I(x4^2)+I(x5^2)+I(x6^2),data=d)
cities.lm3 = lm(y~1+x3,data=d)
cities.lm4 = lm(y~1+x3+x5, data=d)
cities.lm5 = lm(y~1+x3+x5+x3*x5, data=d)

# Residuen anschauen
plot(cities.lm1, which=1)
plot(cities.lm2, which=1)
plot(cities.lm3, which=1)
plot(cities.lm4, which=1)
plot(cities.lm5, which=1)

# log-Transformation
cities.lm1 = lm(log(y) ~ 1+ x1 + x2 + x3 + x4 +x5+x6, data=d)
cities.lm2 = lm(log(y) ~ (1+ x1 + x2 + x3 + x4 +x5+x6)^2+I(x1^2)+I(x2^2)+I(x3^2)+I(x4^2)+I(x5^2)+I(x6^2),data=d)
cities.lm3 = lm(log(y)~1+x3,data=d)
cities.lm4 = lm(log(y)~1+x3+x5, data=d)
cities.lm5 = lm(log(y)~1+x3+x5+x3*x5, data=d)

# Residuen anschauen: Varianzhomogenität scheint nirgends verletzt.
plot(cities.lm1, which=1)
plot(cities.lm2, which=1)
plot(cities.lm3, which=1)
plot(cities.lm4, which=1)
plot(cities.lm5, which=1)

# Vergleiche Prognose-Ergebnisse zweier Modelle
exp(cbind(predict(cities.lm1),predict(cities.lm2)))

# Zerlegung in Trainings- und Testdaten

set.seed(1)
index = sample(1:41, 10)
index
cities.test = d[index,]
cities.train = d[-index,]


# Schätzen der Parameter im Trainingsdatensatz
cities.lm1 = lm(log(y) ~ 1+ x1 + x2 + x3 + x4 +x5+x6, data=cities.train)
cities.lm2 = lm(log(y) ~ (1+ x1 + x2 + x3 + x4 +x5+x6)^2+I(x1^2)+I(x2^2)+I(x3^2)+I(x4^2)+I(x5^2)+I(x6^2),data=cities.train)
cities.lm3 = lm(log(y)~1+x3,data=cities.train)
cities.lm4 = lm(log(y)~1+x3+x5, data=cities.train)
cities.lm5 = lm(log(y)~1+x3+x5+x3*x5, data=cities.train)

# Schätzwert für den erwarteten Prognosefehler
sum((log(cities.test$y)-predict(cities.lm1, newdata =cities.test))^2)
sum((log(cities.test$y)-predict(cities.lm2, newdata =cities.test))^2)
sum((log(cities.test$y)-predict(cities.lm3, newdata =cities.test))^2)
sum((log(cities.test$y)-predict(cities.lm4, newdata =cities.test))^2)
sum((log(cities.test$y)-predict(cities.lm5, newdata =cities.test))^2)

#kreuzvalidierung
index = rep(1:10, length.out=41)
index = sample(index)

SPSE1 = SPSE2 = SPSE3 = SPSE4 = SPSE5 = 0

for (i in 1:10)
{
  cities.test = d[index==i,]
  cities.train = d[index!=i,]
  
  # Modelle erstellen
  cities.lm1 = lm(log(y) ~ 1+ x1 + x2 + x3 + x4 +x5+x6, data=cities.train)
  cities.lm2 = lm(log(y) ~ (1+ x1 + x2 + x3 + x4 +x5+x6)^2+I(x1^2)+I(x2^2)+I(x3^2)+I(x4^2)+I(x5^2)+I(x6^2),data=cities.train)
  cities.lm3 = lm(log(y)~1+x3,data=cities.train)
  cities.lm4 = lm(log(y)~1+x3+x5, data=cities.train)
  cities.lm5 = lm(log(y)~1+x3+x5+x3*x5, data=cities.train)
  
  # Schätzwert für den erwarteten Prognosefehler
  SPSE1 = SPSE1 + sum((log(cities.test$y)-predict(cities.lm1, newdata =cities.test))^2)
  SPSE2 = SPSE2 +sum((log(cities.test$y)-predict(cities.lm2, newdata =cities.test))^2)
  SPSE3 = SPSE3 +sum((log(cities.test$y)-predict(cities.lm3, newdata =cities.test))^2)
  SPSE4 = SPSE4 +sum((log(cities.test$y)-predict(cities.lm4, newdata =cities.test))^2)
  SPSE5 = SPSE5 +sum((log(cities.test$y)-predict(cities.lm5, newdata =cities.test))^2)
}

# Zerlegung mit leaps-package
library(leaps)
cities.subsets = regsubsets(y~1+x1+x2+x3+x4+x5+x6, data=d)
# kleinster cp-Wert ist am besten geeignetes Modell
summary(cities.subsets)$cp
summary(cities.subsets)$which
cbind(summary(cities.subsets)$cp,summary(cities.subsets)$which)
# Nachteile von leaps:
# - varianzhomogenität wird nicht überprüft
# - Wechselwirkungen sind nicht enthalten
# - Linearität wird vorausgesetzt??
# manuelles Erstellen von Modellen ist meistens vorzuziehen