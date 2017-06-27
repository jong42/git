#### Set up working directory and import data
dir = "C:/Users/xi86xev/Desktop/git/Statistische Verfahren"
file_name = "cities.csv"
setwd(dir)
cities.data = read.csv(file_name)

cities.lm0 = lm(y~1, data=cities.data)
cities.lm1 = lm(y~1+x1, data = cities.data)

coef(cities.lm1)
sqrt(vcov(cities.lm1))

test.stat = coef (cities.lm1)[2]/sqrt(vcov(cities.lm1)[2,2])
test.stat

qt(0.975,41-2)

summary(cities.lm1)

###Vorwärtsselektion
add1(cities.lm0,scope=~1+x1+x2+x3+x4+x5+x6)

cities.lm2 = lm(y~1+x2, data=cities.data)
add1(cities.lm2,scope=~1+x1+x2+x3+x4+x5+x6)

add1(cities.lm0,scope=~1+x1+x2+x3+x4+x5+x6,test="F")

x = seq(0,50,0.1)
plot(x,df(x,1,41-2),type="l")
qf(0.95,1,41-2)

cities.lm2 = lm(y~1+x2, data=cities.data)
add1(cities.lm2,scope=~1+x1+x2+x3+x4+x5+x6,test="F")

cities.lm3 = lm(y~1+x2+x3, data=cities.data)
add1(cities.lm3,scope=~1+x1+x2+x3+x4+x5+x6,test="F")

### In R sehr einfach, aber Nachteile:
### -maximaler F-Wert hat selbst keine F-Verteilung
### - einzelne F-Werte sind nicht unabhängig
### - F-Wert kann bei Vorwärtsselektion nicht als
# entscheidendes Kriterium verwendet werden!!
# Als Selektionskriterium muss ein Kriterium verwendet werden,
# dass nicht auf falschen Voraussetzungen basiert


irr.data = read.csv("irrigation1.csv",sep=";")
irr.data$beregnung = relevel(irr.data$beregnung, ref="Kontrolle")

irr.lm0 = lm(ertrag~1, data=irr.data)
irr.lm1 = lm(ertrag~1+sorte, data=irr.data)
irr.lm2 = lm(ertrag~1+sorte+beregnung, data=irr.data)
irr.lm3 = lm(ertrag~1+sorte+beregnung+sorte*beregnung, data=irr.data)

coef(irr.lm2)
anova(irr.lm0,irr.lm1,irr.lm2,irr.lm3)
### Unterschied zu oben: Sachen stehen a priori fest
