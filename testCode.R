## Getting and cleaning data
data <- read.csv("repdata-data-StormData.csv")

validMultiplierLetter <- c('B','K','M','1','2','3','4','5','6','7','8','XXX')
multiplierValues <- c(9,3,6,1,2,3,4,5,6,7,8,0)
names(multiplierValues) <- validMultiplierLetter

propdmg.validExponents <- as.vector(sapply(toupper(data$PROPDMGEXP) , match, validMultiplierLetter, nomatch=match('XXX',validMultiplierLetter)))
data$PROPDMGEXP <- 10^as.numeric(multiplierValues[propdmg.validExponents])

cropdmg.validExponents <- as.vector(sapply(toupper(data$CROPDMGEXP) , match, validMultiplierLetter, nomatch=match('XXX',validMultiplierLetter))) 
data$CROPDMGEXP <- 10^as.numeric(multiplierValues[cropdmg.validExponents])

## Property damage
data$PROPERTYDAMAGE <- data$CROPDMG * data$CROPDMGEXP + data$PROPDMG * data$PROPDMGEXP
propertydamage.byCause <- with (data, aggregate(x=PROPERTYDAMAGE, by=list(factor(data$EVTYPE)), sum))
names(propertydamage.byCause) <- c('cause', 'damage')


##Top 15 candidates:
propertydamage.top15Candidates <- propertydamage.byCause[order(propertydamage.byCause$damage, decreasing=T)[1:15],]

library(ggplot2)
ggplot(data=propertydamage.top15Candidates, aes(x=cause, y=damage)) + geom_bar(aes(fill=cause),stat="identity") + scale_x_discrete(breaks=NULL) + labs(title="Top 15 hazards which damaged property the most")



##Casualties

casualties.deaths <- with(data, aggregate(FATALITIES, by = list(factor(EVTYPE)), sum))
names(casualties.deaths) <- c('cause','deaths')
casualties.deaths.top10 <- casualties.deaths[order(casualties.deaths$deaths, decreasing =T)[1:10],]

casualties.injuries <- with(data, aggregate(INJURIES, by = list(factor(EVTYPE)), sum))
names(casualties.injuries) <- c('cause','injuries')
casualties.injuries.top10 <- casualties.injuries[order(casualties.injuries$injuries, decreasing = T)[1:10],]

p1 <- ggplot(data=casualties.deaths.top10, aes(x=cause, y=deaths)) + geom_bar(aes(fill=cause),stat="identity") + scale_x_discrete(breaks=NULL) + labs(title="10 events with the most deaths") + theme(legend.text=element_text(size=7))
p2 <- ggplot(data=casualties.injuries.top10, aes(x=cause, y=injuries)) + geom_bar(aes(fill=cause),stat="identity") + scale_x_discrete(breaks=NULL) + labs(title="10 events with the most injuries") + theme(legend.text=element_text(size=7))




# ##Casualties
# 
# casualties.deaths <- with(data, aggregate(FATALITIES, by = list(factor(EVTYPE)), sum))
# names(casualties.deaths) <- c('cause','deaths')
# casualties.deaths.top5 <- casualties.deaths[order(casualties.deaths$deaths, decreasing =T)[1:5],]
# 
# casualties.injuries <- with(data, aggregate(INJURIES, by = list(factor(EVTYPE)), sum))
# names(casualties.injuries) <- c('cause','injuries')
# casualties.injuries.top5 <- casualties.injuries[order(casualties.injuries$injuries, decreasing = T)[1:5],]
# 
# library(grid)
# library(gridExtra)
# p1 <- ggplot(data=casualties.deaths.top5, aes(x=cause, y=deaths)) + geom_bar(aes(fill=cause),stat="identity") + scale_x_discrete(breaks=NULL) + labs(title="15 events with the most deaths")
# p2 <- ggplot(data=casualties.injuries.top5, aes(x=cause, y=injuries)) + geom_bar(aes(fill=cause),stat="identity") + scale_x_discrete(breaks=NULL) + labs(title="15 events with the most deaths")
# 
# grid.arrange(p1, p2, ncol=1)