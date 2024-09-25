#### Preamble ####
# Purpose: This script automates the retrieval, extraction, and saving of the 
# "Daily Shelter & Overnight Service Occupancy & Capacity" dataset from Open Data Toronto, 
# including the raw data.
# Author: Yiyue Deng 
# Date: 24 September 2024 
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# # Pre-requisites: Ensure the 'opendatatoronto' and 'tidyverse' R packages are installed and loaded before executing.


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

#### Simulate ID and Organizational Data ####
num_days <- 365
total_rows <- num_shelters * num_days

simulated_ID <- tibble(
  Shelter_ID = rep(1000:1100, each = num_days, length.out = total_rows),
  Organization_ID = rep(2000:2050, each = num_days, length.out = total_rows),
  Organization_Name = rep(sample(c("Org A", "Org B", "Org C"), num_shelters, replace = TRUE), each = num_days),
  Date = rep(seq.Date(as.Date("2023-01-01"), length.out = num_days, by = "day"), num_shelters),
  Shelter_Group = rep(sample(c("Group 1", "Group 2", "Group 3"), num_shelters, replace = TRUE), each = num_days)
)

# Preview the ID data
head(simulated_ID)

# Save the ID data
write_csv(simulated_ID, file = "data/raw_data/simulated_id_data.csv")

#### Simulate Numerical Data (Occupancy and Capacity) ####
set.seed(1234) # Ensure reproducibility
max_capacity <- 150

simulated_numerical <- tibble(
  Date = rep(seq.Date(as.Date("2023-01-01"), length.out = num_days, by = "day"), num_shelters),
  Shelter_ID = rep(1000:1100, each = num_days, length.out = total_rows),
  Capacity_Beds = sample(100:150, total_rows, replace = TRUE),
  Occupied_Beds = rpois(total_rows, lambda = 80), # Simulating occupancy with a mean of 80
  Capacity_Rooms = sample(50:100, total_rows, replace = TRUE),
  Occupied_Rooms = rpois(total_rows, lambda = 40), # Simulating room occupancy with a mean of 40
  Unoccupied_Beds = Capacity_Beds - Occupied_Beds,
  Unoccupied_Rooms = Capacity_Rooms - Occupied_Rooms
)

# Adjust for logical consistency: Occupancy should not exceed capacity
simulated_numerical <- simulated_numerical %>%
  mutate(
    Occupied_Beds = pmin(Occupied_Beds, Capacity_Beds),
    Occupied_Rooms = pmin(Occupied_Rooms, Capacity_Rooms),
    Unoccupied_Beds = Capacity_Beds - Occupied_Beds,
    Unoccupied_Rooms = Capacity_Rooms - Occupied_Rooms,
    Bed_Occupancy_Rate = Occupied_Beds / Capacity_Beds,
    Room_Occupancy_Rate = Occupied_Rooms / Capacity_Rooms
  )

# Preview the numerical data
head(simulated_numerical)

# Save the numerical data
write_csv(simulated_numerical, file = "data/raw_data/simulated_numerical_data.csv")

#### Simulate Additional Variables (Service User Count) ####
simulated_numerical <- simulated_numerical %>%
  mutate(Service_User_Count = Occupied_Beds + Occupied_Rooms)

# Save the updated numerical data with additional variables
write_csv(simulated_numerical, file = "data/raw_data/simulated_numerical_with_users.csv")

#### Data Checks ####
# Ensure Occupied_Beds and Occupied_Rooms do not exceed their respective capacities
test_occupancy_consistency <- all(simulated_numerical$Occupied_Beds <= simulated_numerical$Capacity_Beds) &&
  all(simulated_numerical$Occupied_Rooms <= simulated_numerical$Capacity_Rooms)
print(test_occupancy_consistency) # Should return TRUE

# Ensure no negative values
test_no_negative_values <- all(simulated_numerical$Occupied_Beds >= 0) && 
  all(simulated_numerical$Occupied_Rooms >= 0)
print(test_no_negative_values) # Should return TRUE

# Ensure the dataset has correct date ranges
test_date_range <- min(simulated_numerical$Date) == as.Date("2023-01-01") &&
  max(simulated_numerical$Date) == as.Date("2023-12-31")
print(test_date_range) # Should return TRUE
