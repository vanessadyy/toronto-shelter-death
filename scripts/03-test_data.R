#### Preamble ####
# Purpose: 
# Tests the consistency and integrity of simulated shelter data, ensuring logical accuracy 
# in occupancy and capacity, and validates date ranges.
# Author: Yiyue Deng 
# Date: 24 September 2024 
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - Install and load tidyverse library
# - Ensure 'simulated_numerical_data.csv' is generated and saved in 'data/raw_data/' folder
# Any other information needed?
# - This script performs basic validation checks; further statistical analysis may be required later.


#### Workspace setup ####
# Load necessary libraries
library(tidyverse)

#### Test data ####
# Read the simulated numerical data
simulated_numerical <- read_csv("data/raw_data/simulated_numerical_data.csv")

#### Simulate Additional Variables (Service User Count) ####
# Add a new column that calculates the total service user count
simulated_numerical <- simulated_numerical %>%
  mutate(Service_User_Count = Occupied_Beds + Occupied_Rooms)

# Save the updated numerical data with the new variable
write_csv(simulated_numerical, file = "data/raw_data/simulated_numerical_with_users.csv")

#### Data Checks ####
# Ensure Occupied_Beds and Occupied_Rooms do not exceed their respective capacities
test_occupancy_consistency <- all(simulated_numerical$Occupied_Beds <= simulated_numerical$Capacity_Beds) &&
  all(simulated_numerical$Occupied_Rooms <= simulated_numerical$Capacity_Rooms)
print(test_occupancy_consistency) # Should return TRUE

# Ensure no negative values for occupancy
test_no_negative_values <- all(simulated_numerical$Occupied_Beds >= 0) && 
  all(simulated_numerical$Occupied_Rooms >= 0)
print(test_no_negative_values) # Should return TRUE

# Ensure the date range is correct (from 2023-01-01 to 2023-12-31)
test_date_range <- min(simulated_numerical$Date) == as.Date("2023-01-01") &&
  max(simulated_numerical$Date) == as.Date("2023-12-31")
print(test_date_range) # Should return TRUE



