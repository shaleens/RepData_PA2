data <- read.csv("repdata-data-StormData.csv")

validMultiplierLetter <- c('B','K','M','X')
multiplierValues <- c(1000000000, 1000, 1000000, 0)
names(multiplierValues) <- validMultiplierLetter

propdmg.validMultipliers <- as.vector(sapply(toupper(data$PROPDMGEXP) , match, validMultiplierLetter, nomatch=4))
data$PROPDMGEXP <- as.vector(multiplierValues[propdmg.validMultipliers])

cropdmg.validMultipliers <- as.vector(sapply(toupper(data$CROPDMGEXP) , match, validMultiplierLetter, nomatch=4)) 
data$CROPDMGEXP <- as.vector(multiplierValues[cropdmg.validMultipliers])

head(data[data$PROPDMG != 0, ])