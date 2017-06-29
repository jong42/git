#### Set up working directory and import data
dir = "C:/Users/xi86xev/Desktop/git/Statistische Verfahren"
file_name = "galapagos.csv"
setwd(dir)
gala.data = read.csv(file_name)

plot(species~logarea,data=gala.data)

score = function(beta)
{
  c(sum(y-exp(beta[1]+beta[2]*x)),
    sum((y-exp(beta[1]+beta[2]*x))*x))
}

fisher = function(beta)
{
  I00 = sum(exp(beta[1]+beta[2]*x))
  I01 = sum(exp(beta[1]+beta[2]*x)*x)
  I11 = sum(exp(beta[1]+beta[2]*x)*x^2)
  matrix(c(I00,I01,I01,I11),2,2)
}

betaalt = c(0,1)
eps = 0.0001
y = gala.data$species
x = gala.data$logarea

repeat
{
  betaneu = betaalt + solve(fisher(betaalt)) %*% score (betaalt)
  print (betaneu)
  if (sum((betaneu-betaalt)^2)/sum(betaalt^2)<eps) break
     betaalt = betaneu
  
}


### mit glm()-Funktion
gala.glm1 = glm(species~1+logarea, data=gala.data, family=poisson(link="log"))

points(x,predict(gala.glm1),pch=16, col=2)
points(x,exp(predict(gala.glm1)),pch=16, col=3)
points(x,predict(gala.glm1,type="response"),pch=16, col=4)

gala.glm2 = glm(species~1+logarea, data=gala.data, family=poisson(link="sqrt"))


lm(sqrt(species)~1+logarea, data=gala.data)
gala.glm2 = glm(species~1+logarea, data=gala.data, family=poisson(link="sqrt"),start =c(5.453,1.346))

# Startwerte etwas abändern
gala.glm2 = glm(species~1+logarea, data=gala.data, family=poisson(link="sqrt"),start =c(6,1))
points(x,predict(gala.glm2,type="response"),pch=16, col=5)

solve(fisher(betaneu))

vcov(gala.glm1)
confint(gala.glm1)
