#### Preamble ####
# Purpose: 
# Simulate categorical and numerical data for Toronto shelter services, including sectors, program types, 
# and shelter capacity and occupancy information.
# Author: Yiyue Deng 
# Date: 24 September 2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - Ensure 'tidyverse' and 'janitor' packages are installed and loaded.

#### Workspace Setup ####
library(tidyverse)
library(janitor)

#### Set Seed for Reproducibility ####
set.seed(123)

#### Simulate Categorical Data ####
num_shelters <- 150
num_days <- 365  # Simulating for the whole year (365 days)

# Simulating categorical data for shelters
simulated_categorical <- tibble(
  Division = 1:num_shelters,
  Sector = sample(c("Men", "Women", "Mixed Adult", "Youth", "Family"), num_shelters, replace = TRUE),
  Program_Model = sample(c("Emergency", "Transitional"), num_shelters, replace = TRUE),
  Overnight_Service_Type = sample(
    c("Shelter", "24-Hour Respite", "Motel/Hotel", "Interim Housing", "Warming Centre", "24-Hour Women’s Drop-in", "Isolation/Recovery Site"),
    num_shelters, replace = TRUE
  ),
  Program_Area = sample(
    c("Base Shelter and Overnight Services System", "Base Program - Refugee", "Temporary Refugee Response", 
      "COVID-19 Response", "Winter Response"), num_shelters, replace = TRUE
  )
)

# Simulate a 'date' column with a complete range from 2023-01-01 to 2023-12-31
date_range <- seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "day")
dates <- rep(date_range, length.out = num_shelters * num_days)

# Repeat categorical data for each day of the year
simulated_categorical <- simulated_categorical[rep(1:num_shelters, each = num_days), ]
simulated_categorical <- simulated_categorical %>% mutate(date = dates)

#### Simulate Numerical Data ####
# Simulating numerical data for beds and rooms for each day
simulated_numerical <- tibble(
  Capacity_Beds = sample(100:500, num_shelters * num_days, replace = TRUE),
  Occupied_Beds = sample(50:450, num_shelters * num_days, replace = TRUE),
  Capacity_Rooms = sample(50:200, num_shelters * num_days, replace = TRUE),
  Occupied_Rooms = sample(30:180, num_shelters * num_days, replace = TRUE)
)

# Combine categorical and numerical data
simulated_data <- bind_cols(simulated_categorical, simulated_numerical)

# Preview combined data
head(simulated_data)

#### Save Simulated Data ####
write_csv(simulated_data, file = "data/raw_data/simulated_shelter_data.csv")

