library(tidyverse)
library(data.table)

political_data <- read_csv("finalProjectData.csv")%>% #from John's sources
  dplyr::select(c(1,3,4,6:18))

covid <- read_csv("covid_kaggle.csv") #from kaggle
sociohealth <- read_csv("socio-healthdata.csv") #from kaggle


#calculates the deathrate
covid <- covid %>%
  group_by(fips) %>%
  summarise(case_count = sum(cases),
            death_count = sum(deaths)) %>%
  mutate(covid_death_rate = death_count/case_count,
         covid_death_rate_log = log(death_count/case_count))  


#selects some predictor variables and joins with covid data
covid <- sociohealth %>%
  select(fips,
         lon, 
         lat,
         per_capita_income,
         percent_below_poverty,
         percent_minorities,
         percentile_rank_social_vulnerability,
         percent_uninsured,
         total_population,
         area_sqmi,
         percent_smokers,
         percent_fair_or_poor_health) %>%
  left_join(.,covid, by = c("fips")) %>%
  mutate(fips = as.numeric(fips))

#joins data to the political data 
mydata <- left_join(political_data, covid, by = c("FIPS" = "fips"))

#saves data into a file
write.csv(mydata, "covid.csv")
#source for covid socioeconomic data: https://www.kaggle.com/johnjdavisiv/us-counties-covid19-weather-sociohealth-data


