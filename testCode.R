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