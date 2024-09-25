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

#### Workspace Setup ####
library(tidyverse)
library(janitor)

#### Simulate ID and Organizational Data ####
num_shelters <- 150  # Number of shelters
num_days <- 365      # Number of days in the year
total_rows <- num_shelters * num_days

# Simulating shelter and organization IDs, and adding shelter group and organization name
simulated_ID <- tibble(
  Shelter_ID = rep(1000:(1000 + num_shelters - 1), each = num_days, length.out = total_rows),
  Organization_ID = rep(2000:(2000 + num_shelters - 1), each = num_days, length.out = total_rows),
  Organization_Name = rep(sample(c("Org A", "Org B", "Org C"), num_shelters, replace = TRUE), each = num_days),
  Date = rep(seq.Date(as.Date("2023-01-01"), length.out = num_days, by = "day"), num_shelters),
  Shelter_Group = rep(sample(c("Group 1", "Group 2", "Group 3"), num_shelters, replace = TRUE), each = num_days)
)

# Preview the simulated organizational data
head(simulated_ID)

# Save the simulated organizational data
write_csv(simulated_ID, file = "data/raw_data/simulated_id_data.csv")

#### Simulate Numerical Data (Occupancy and Capacity) ####
set.seed(1234)  # Ensure reproducibility
max_capacity <- 150  # Maximum bed capacity

simulated_numerical <- tibble(
  Date = rep(seq.Date(as.Date("2023-01-01"), length.out = num_days, by = "day"), num_shelters),
  Shelter_ID = rep(1000:(1000 + num_shelters - 1), each = num_days, length.out = total_rows),
  Capacity_Beds = sample(100:150, total_rows, replace = TRUE),  # Random bed capacities
  Occupied_Beds = rpois(total_rows, lambda = 80),  # Simulated bed occupancy with a mean of 80
  Capacity_Rooms = sample(50:100, total_rows, replace = TRUE),  # Random room capacities
  Occupied_Rooms = rpois(total_rows, lambda = 40),  # Simulated room occupancy with a mean of 40
  Unoccupied_Beds = Capacity_Beds - Occupied_Beds,
  Unoccupied_Rooms = Capacity_Rooms - Occupied_Rooms
)

# Adjust for logical consistency: Ensure that occupancy doesn't exceed capacity
simulated_numerical <- simulated_numerical %>%
  mutate(
    Occupied_Beds = pmin(Occupied_Beds, Capacity_Beds),
    Occupied_Rooms = pmin(Occupied_Rooms, Capacity_Rooms),
    Unoccupied_Beds = Capacity_Beds - Occupied_Beds,
    Unoccupied_Rooms = Capacity_Rooms - Occupied_Rooms,
    Bed_Occupancy_Rate = Occupied_Beds / Capacity_Beds,  # Calculate bed occupancy rate
    Room_Occupancy_Rate = Occupied_Rooms / Capacity_Rooms  # Calculate room occupancy rate
  )

# Preview the simulated numerical data
head(simulated_numerical)

# Save the simulated numerical data
write_csv(simulated_numerical, file = "data/raw_data/simulated_numerical_data.csv")

#### Load and Clean Real Data (If Applicable) ####
# Optionally, load the actual raw data for cleaning if available
# raw_data <- read_csv("data/raw_data/daily_shelter_occupancy_2023.csv")

# Clean the real data (Remove unnecessary columns, handle missing values, format dates)
# cleaned_data <- raw_data %>%
#   select(-c(UnnecessaryColumn1, UnnecessaryColumn2)) %>%  # Replace with actual column names
#   clean_names() %>%  # Clean column names
#   drop_na() %>%  # Remove rows with NA values
#   mutate(date = as.Date(date, format = "%Y-%m-%d"))  # Ensure correct date format

# Save cleaned real data (If Applicable)
# write_csv(cleaned_data, file = "data/cleaned_data/shelter_cleaned_data.csv")

