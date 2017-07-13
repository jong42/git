#### Set up working directory and import data
dir = "C:/Users/xi86xev/Desktop/git/Statistische Verfahren"
file_name = "offenboden.csv"
setwd(dir)
offen.data = read.csv(file_name)

plot(vorkommen~offen, data=offen.data)

offen.int = cut(offen.data$offen,breaks=seq(0,40,7))

rel.hfk = tapply(offen.data$vorkommen,offen.int,mean)

offen.mid = seq(3.5,by=7,length.out=5)
points(offen.mid,rel.hfk,col=2)

offen.glm1 = glm(vorkommen~1+offen, data=offen.data,family=binomial(link="logit"))
points(offen.data$offen,predict(offen.glm1, type="response"),pch=16,col=3)

offen.glm2 = glm(vorkommen~1+offen+I(offen^2), data=offen.data,family=binomial(link="logit"))
points(offen.data$offen,predict(offen.glm2, type="response"),pch=16,col=4)

summary(offen.glm1)
summary(offen.glm2)

anova(offen.glm1,offen.glm2, test="LRT")

2*(logLik(offen.glm2) - logLik(offen.glm1))

AIC(offen.glm1,offen.glm2)
