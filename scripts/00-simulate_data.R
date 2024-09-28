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
library(tidyverse)  # Load 'tidyverse' for data manipulation functions like 'mutate', 'round', 'ifelse'
library(lubridate)  # Load 'lubridate' for easy manipulation of dates, such as extracting months and years

#### Set Seed for Reproducibility ####
set.seed(123)  # Set a seed value to ensure that the random numbers generated are reproducible

#### Data simulation ####

# Date simulation
dt <- tibble(date = seq(as.Date("2007-01-01"), as.Date("2024-08-01"), by = "month"))
# Create a tibble (data frame) containing a sequence of dates, starting from 2007-01-01 
# to 2024-08-01, incremented by 'month'

dt <- dt %>% mutate(
  Month = month(date),  # Extract month from the 'date' column
  Year = year(date)     # Extract year from the 'date' column
)

# Death number simulation
dt <- dt %>% mutate(
  Male = round(rnorm(nrow(dt), mean = 5, sd = 2)),  # Simulate male death counts using normal distribution
  Female = round(rnorm(nrow(dt), mean = 2, sd = 2)),  # Simulate female death counts using normal distribution
  OtherGender = round(rnorm(nrow(dt), mean = 0, sd = 2)),  # Simulate other gender death counts
  
  # Constrain the values to be within 0 and 20
  Male = ifelse(Male < 0, 0, ifelse(Male > 20, 20, Male)),  # Cap male death counts between 0 and 20
  Female = ifelse(Female < 0, 0, ifelse(Female > 20, 20, Female)),  # Cap female death counts between 0 and 20
  OtherGender = ifelse(OtherGender < 0, 0, ifelse(OtherGender > 20, 20, OtherGender)),  # Cap other gender death counts between 0 and 20
  
  # Set 'OtherGender' deaths to zero before 2020-01-01
  OtherGender = ifelse(date > as.Date("2020-01-01"), OtherGender, 0),
  
  # Calculate total deaths as the sum of male, female, and other gender deaths
  Total_Death = Male + Female + OtherGender,
  
  # For consistency, set 'OtherGender' to NA for dates after 2020-01-01
  OtherGender = ifelse(date > as.Date("2020-01-01"), OtherGender, NA)
)

# Format variables
dt <- dt %>% mutate(
  Male = as.integer(Male),  # Convert male death counts to integer type
  Female = as.integer(Female),  # Convert female death counts to integer type
  Month = month.abb[Month],  # Convert numerical month to abbreviated month name (e.g., Jan, Feb)
  Year = as.integer(Year),  # Convert year to integer type
  Total_Death = as.integer(Total_Death),  # Convert total deaths to integer type
  OtherGender = as.integer(OtherGender)  # Convert other gender death counts to integer type
)

#### Save Simulated Data ####
# Set directory
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/../data/raw_data/simulated.csv")
# Combine the current working directory with the relative path to the destination file

# Save
write_csv(dt, fd)  # Write the simulated data to a CSV file
