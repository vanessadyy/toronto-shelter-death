#### Preamble ####
# Purpose:
# Simulates and cleans shelter data (organization, capacity, occupancy) 
# for 150 shelters over one year, ensuring data consistency. 
# Outputs cleaned data for further analysis.
# Author: Yiyue Deng 
# Date: 24 September 2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - Install and load necessary libraries: tidyverse
# - Ensure 'num_shelters' variable is defined before running the script
# - The folder 'data/raw_data/' should exist to store the generated files

# Any other information needed?
# - This script simulates organizational and numerical data for shelters over one year (365 days).
# - The generated data is saved as CSV files in the 'data/raw_data/' folder.
# - Ensure that the simulated data files will be used in subsequent analysis and testing scripts.

#### Workspace setup ####
library(tidyverse)

#### Clean data ####
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

