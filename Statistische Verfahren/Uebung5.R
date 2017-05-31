#### Set up working directory and import data
dir = "/home/xi86xev/git/git/Statistische Verfahren"
file_name = "mietspiegel99.csv"
setwd(dir)
d = read.csv(file_name)


library(stats4)
fit = lm(mieteqm ~ 1/flaeche,d)
summary(fit)
mle()