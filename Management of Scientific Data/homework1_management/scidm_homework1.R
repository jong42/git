setwd("/home/xi86xev/Schreibtisch/homework1_management")


d = read.csv("00_smallaphiddataset.csv",sep=";",header=TRUE,skip=1)

d = d[-(1:2),]

###############################
### Do basic data cleansing
###############################


# sample_date seems to be fine; no inconsistent values; no missing values
unique(d$sample_date)
unique(is.na(d$sample_date))

# state seems to be fine; no inconsistent values; no missing values; 
# no duplicate abbreviations for the same state
unique(d$state)
unique(is.na(d$state))
plot(d$state, ylab ="frequency", xlab = "state")


# station has inconsistent values: abbreviations in capital letters
#                                  typos and different writings at Lancaster
# station names NEPAC, SEPAC, PPAC, DPAC, ACRE, PIT deviate from the others in form, but since
# the domain of the column is unknown, they could be legal values, so they are kept
unique(d$station)

# no missing values
unique(is.na(d$station))

# Add new levels to factor variable
d$station = factor(d$station,levels=c(levels(d$station), "Morris"))

# correct spelling errors
d$station[which(d$station=="Lancester"|d$station=="lancaster"|d$station=="Lancaste")] = "Lancaster"
d$station[which(d$station=="Hancokk")] = "Hancock"
d$station[which(d$station=="PERRY")] = "Perry"
d$station[which(d$station=="Alington")] = "Arlington"
d$station[which(d$station=="MorrisIL"|d$station=="MorrisMN")] = "Morris"

unique(d$station)
plot(d$station)

# species has no incosistent values
unique(d$species)
# no missing values
unique(is.na(d$species))
d$species[which(d$species=="unknown")] = NA

# two different writing styles for sex
unique(d$sex)
# no missing values
unique(d$sex)
plot(d$sex)
# harmonize writing style
d$sex[which(d$sex=="male")] = "M"
d$sex[which(d$sex=="female")] = "F"

# inconsistent values are existing for count
unique(d$count)
# class is factor. should be numeric
class(d$count)
# no missing values
unique(is.na(d$count))

# harmonize values
d$count[which(d$count=="<3"|d$count=="?"|d$count=="??"|d$count=="")] = NA

# convert to numeric
d$count = as.numeric(as.character(d$count))

###############################
### split up species names
###############################

d$species = as.character(d$species)

d$genus = sapply(d$genus,function(x) {strsplit(x,"\\.")[1]})
strsplit(d$species,"\\.")
