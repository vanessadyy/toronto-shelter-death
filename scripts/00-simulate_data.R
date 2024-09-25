#### Preamble ####
# Purpose:
# Automates the retrieval, extraction, and saving of the "Daily Shelter & Overnight Service Occupancy & Capacity" 
# dataset from Open Data Toronto, including raw data.
# Author: Yiyue Deng 
# Date: 24 September 2024 
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - Ensure 'opendatatoronto' and 'tidyverse' packages are installed and loaded.


#### Workspace Setup ####
# Load necessary libraries for data manipulation and cleaning
library(tidyverse)
library(janitor)

#### Simulate Categorical Data ####
set.seed(123) # Ensure reproducibility
num_shelters <- 150

# Simulating categorical information for shelters
simulated_categorical <- tibble(
  Division = 1:num_shelters,
  Sector = sample(c("Men", "Women", "Mixed Adult", "Youth", "Family"), num_shelters, replace = TRUE),
  Program_Model = sample(c("Emergency", "Transitional"), num_shelters, replace = TRUE),
  Overnight_Service_Type = sample(
    c("Shelter", "24-Hour Respite", "Motel/Hotel", "Interim Housing", 
      "Warming Centre", "24-Hour Women's Drop-in", "Isolation/Recovery Site"),
    num_shelters, replace = TRUE
  ),
  Program_Area = sample(
    c("Base Shelter and Overnight Services System", "Base Program - Refugee", 
      "Temporary Refugee Response", "COVID-19 Response", "Winter Response"), 
    num_shelters, replace = TRUE
  )
)

# Preview the categorical data
head(simulated_categorical)

# Save the categorical data
write_csv(simulated_categorical, file = "data/raw_data/simulated_categorical_data.csv")
