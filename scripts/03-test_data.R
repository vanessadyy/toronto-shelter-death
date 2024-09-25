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

#### Workspace Setup ####
library(tidyverse)

# Create the 'data/final' directory if it does not exist
if (!dir.exists("data/final")) {
  dir.create("data/final", recursive = TRUE)
}

#### Load the Simulated Data ####
simulated_data <- read_csv("data/raw_data/simulated_shelter_data.csv", show_col_types = FALSE)

#### Column Type Validation ####
# Check and enforce proper column types for required columns
required_columns <- c("Occupied_Beds", "Occupied_Rooms", "Capacity_Beds", "Capacity_Rooms")
missing_columns <- setdiff(required_columns, colnames(simulated_data))

if (length(missing_columns) > 0) {
  stop(paste("Missing required columns:", paste(missing_columns, collapse = ", ")))
} else {
  # Ensure the required columns are numeric
  simulated_data <- simulated_data %>%
    mutate(across(c(Occupied_Beds, Occupied_Rooms, Capacity_Beds, Capacity_Rooms), as.numeric))
}

#### Ensure Date Column Exists and Parse It ####
# Check if the 'date' column exists
if (!"date" %in% colnames(simulated_data)) {
  warning("The 'date' column is missing. Simulating date column.")
  
  # Simulate date column with a complete date range from 2023-01-01 to 2023-12-31
  num_rows <- nrow(simulated_data)
  dates <- seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "day")
  simulated_data <- simulated_data %>%
    mutate(date = rep(dates, length.out = num_rows))
} else {
  # Ensure the 'date' column is correctly formatted and handle invalid entries
  simulated_data <- simulated_data %>%
    mutate(date = as.Date(date, format = "%Y-%m-%d"))
  
  if (any(is.na(simulated_data$date))) {
    stop("Date parsing failed. Please check the 'date' column for invalid entries.")
  }
}

#### Simulate Additional Variables (Service User Count) ####
# Add a new column to calculate the total service user count (Occupied Beds + Occupied Rooms)
simulated_data <- simulated_data %>%
  mutate(Service_User_Count = Occupied_Beds + Occupied_Rooms)

#### Ensure Data Consistency ####
# Ensure that 'Occupied_Beds' and 'Occupied_Rooms' do not exceed their respective capacities
simulated_data <- simulated_data %>%
  mutate(
    Occupied_Beds = pmin(Occupied_Beds, Capacity_Beds),
    Occupied_Rooms = pmin(Occupied_Rooms, Capacity_Rooms)
  )

# Save the updated data with new variables
write_csv(simulated_data, file = "data/raw_data/simulated_shelter_data_with_users.csv")

#### Perform Data Checks ####

# 1. Check that 'Occupied_Beds' and 'Occupied_Rooms' do not exceed their respective capacities
test_occupancy_consistency <- all(simulated_data$Occupied_Beds <= simulated_data$Capacity_Beds, na.rm = TRUE) &&
  all(simulated_data$Occupied_Rooms <= simulated_data$Capacity_Rooms, na.rm = TRUE)

if (!test_occupancy_consistency) {
  warning("Some rows have occupancy exceeding capacity.")
  inconsistent_rows <- simulated_data %>%
    filter(Occupied_Beds > Capacity_Beds | Occupied_Rooms > Capacity_Rooms)
  print(inconsistent_rows)
}
print(paste("Occupancy within capacity:", test_occupancy_consistency))  # Expected TRUE

# 2. Ensure there are no negative values for occupancy
test_no_negative_values <- all(simulated_data$Occupied_Beds >= 0, na.rm = TRUE) && 
  all(simulated_data$Occupied_Rooms >= 0, na.rm = TRUE)

if (!test_no_negative_values) {
  warning("Some rows contain negative occupancy values.")
  negative_rows <- simulated_data %>%
    filter(Occupied_Beds < 0 | Occupied_Rooms < 0)
  print(negative_rows)
}
print(paste("No negative occupancy values:", test_no_negative_values))  # Expected TRUE

# 3. Check that the date range is correct (from 2023-01-01 to 2023-12-31)
test_date_range <- min(simulated_data$date, na.rm = TRUE) == as.Date("2023-01-01") &&
  max(simulated_data$date, na.rm = TRUE) == as.Date("2023-12-31")

if (!test_date_range) {
  warning("Date range is incorrect.")
  print(paste("Date range is from", min(simulated_data$date), "to", max(simulated_data$date)))
}
print(paste("Date range correct:", test_date_range))  # Expected TRUE

#### Summary of Tests ####
# Final summary of all tests
if (test_occupancy_consistency & test_no_negative_values & test_date_range) {
  print("All tests passed successfully!")
  # Save the final validated data
  write_csv(simulated_data, file = "data/final/simulated_shelter_data_with_users.csv")
} else {
  print("Some tests failed, please review the data.")
}

