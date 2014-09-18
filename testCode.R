data <- read.csv("repdata-data-StormData.csv")

validMultiplierLetter <- c('B','K','M','1','2','3','4','5','6','7','8','XXX')
multiplierValues <- c(9,3,6,1,2,3,4,5,6,7,8,0)
names(multiplierValues) <- validMultiplierLetter

propdmg.validExponents <- as.vector(sapply(toupper(data$PROPDMGEXP) , match, validMultiplierLetter, nomatch=match('XXX',validMultiplierLetter)))
data$PROPDMGEXP <- 10^as.numeric(multiplierValues[propdmg.validExponents])

cropdmg.validExponents <- as.vector(sapply(toupper(data$CROPDMGEXP) , match, validMultiplierLetter, nomatch=match('XXX',validMultiplierLetter))) 
data$CROPDMGEXP <- 10^as.numeric(multiplierValues[cropdmg.validExponents])

