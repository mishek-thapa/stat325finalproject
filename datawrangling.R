library(tidyverse)
library(data.table)


mydata <- read_csv("finalProjectData.csv")
descriptions <- read_csv("descriptions.csv")


#adds up case counts and death counts

case_columns <- colnames(mydata) %like% "Cases"
death_columns <- c(colnames(mydata) %like% "Deaths", FALSE)


mydata$casecount <-  rowSums(mydata[,case_columns])
mydata$deathcount <- rowSums(mydata[,death_columns])

#remove individual day counts and add death rate
#added log transformation
columnstoremove <- colnames(mydata) %like% "Cases" |colnames(mydata) %like% "Deaths"

mydata <- mydata[,-which(columnstoremove)]
mydata <- mydata %>%
  mutate(death_rate = deathcount/casecount,
         death_rate_log = log(death_rate))


write.csv(mydata, "covid.csv")









