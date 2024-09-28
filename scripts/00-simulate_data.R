#### Preamble ####
# Purpose: 
# Simulate categorical and numerical variables for Toronto shelter death data 
# Author: Yiyue Deng 
# Date: 24 September 2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - Ensure 'tidyverse' and 'lubridate' package is installed and loaded.

#### Setup ####
library(tidyverse)
library(lubridate)


#### Set Seed for Reproducibility ####
set.seed(123)

#### Data simulation ####

#Date simulation
dt <- tibble(date = seq(as.Date("2007-01-01"), as.Date("2024-08-01"), by = "month"))

dt <- dt %>% mutate(
  Month=month(date),
  Year=year(date)
)

#Death number simulation

dt <- dt %>% mutate(
  Male = round(rnorm(nrow(dt),mean=5,sd=2)),
  Female = round(rnorm(nrow(dt),mean=2,sd=2)),
  OtherGender = round(rnorm(nrow(dt),mean=0,sd=2)),
  # Constrain the values to be within 0 and 20
  Male = ifelse(Male < 0, 0, ifelse(Male > 20, 20, Male)),
  Female = ifelse(Female < 0, 0, ifelse(Female > 20, 20, Female)),
  OtherGender = ifelse(OtherGender < 0, 0, ifelse(OtherGender > 20, 20, OtherGender)),
  OtherGender = ifelse(date>as.Date("2020-01-01"),OtherGender,0),
  Total_Death = Male+Female+OtherGender,
  OtherGender = ifelse(date>as.Date("2020-01-01"),OtherGender,NA)
)

#Format variables
dt <- dt %>% mutate(
  Male=as.integer(Male),
  Female=as.integer(Female),
  Month=month.abb[Month],
  Year=as.integer(Year),
  Total_Death=as.integer(Total_Death),
  OtherGender =as.integer(OtherGender ),
)


#### Save Simulated Data ####
#Set directory
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/../data/raw_data/simulated.csv")
#Save
write_csv(dt, fd)

