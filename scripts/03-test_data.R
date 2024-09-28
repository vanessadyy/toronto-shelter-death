#### Preamble ####
# Purpose:
# Ensure all values from simulated data are within reasonable ranges.
# Author: Yiyue Deng
# Date: 28 September 2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - Install and load tidyverse and testthat library
# - Run 00-simulate_data.R first to generate the necessary simulated data.
# Any other information needed?
# - This script performs basic validation checks; further statistical analysis may be required later.

#### Setup ####
library(tidyverse)  # Load 'tidyverse' for data manipulation functions
library(testthat)   # Load 'testthat' for running validation tests

# Set data directory
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/../")  
# Construct the path to the project root folder by combining the current script directory with "../"
setwd(fd)  # Set the working directory to the root folder

#### Load the Simulated Data ####
simulated_data <- read_csv("./data/raw_data/simulated.csv", show_col_types = FALSE)  
# Load the simulated data from 'simulated.csv' without displaying column type information

# Column name validation
required_columns <- c("Month", "Year", "Male", "Female", "Total_Death", "Time")  
# Define the required columns that must exist in the dataset

missing_columns <- setdiff(required_columns, colnames(simulated_data))  
# Check for any missing required columns by finding the difference between the expected and actual column names

ifelse(length(missing_columns) > 0, paste("Missing required columns:", missing_columns), paste("Column names matched"))
# If there are missing columns, display a message showing which ones are missing; otherwise, confirm that column names match

### Simulated data used a different name for "Time"
### Correct it and move on
simulated_data <- simulated_data %>% rename(Time = date)  
# Rename the 'date' column to 'Time' to match the required column name

# Column name recheck
missing_columns <- setdiff(required_columns, colnames(simulated_data))  
# Recheck to ensure all required columns are present after the renaming

ifelse(length(missing_columns) > 0, paste("Missing required columns:", missing_columns), paste("Column names matched"))
# Again, if any required columns are missing, show which ones are missing; otherwise, confirm the column names match

#### Column Type Validation ####
# Ensure the required columns are integers
simulated_data <- simulated_data %>%
  mutate(
    across(c(Year, Total_Death, Male, Female, OtherGender), as.integer),  
    # Convert the 'Year', 'Total_Death', 'Male', 'Female', and 'OtherGender' columns to integer type
    Time = as.Date(Time)  
    # Convert the 'Time' column to date type to ensure consistency
  )

# Check ranges of integer variables
summary(simulated_data)  
# Generate a summary of the dataset to inspect the ranges and distribution of the integer variables

# Drop OtherGender due to too much missing values and as it is not included in the cleaned data
simulated_data <- simulated_data %>% select(-OtherGender)  
# Remove the 'OtherGender' column, as it contains too many missing values and is not used in the cleaned data

#### Test: No Missing Values ####
# Test that there are no missing values in the dataset
test_that("no missing values in dataset", {
  expect_true(all(!is.na(simulated_data)))  
  # Check that all values in the dataset are not missing (i.e., there are no NA values)
})

#### Test: Valid Month Values ####
# Test that 'Month' contains only valid month abbreviations
valid_Month <- month.abb[1:12]  
# Define the valid month abbreviations (Jan, Feb, ..., Dec)

test_that("'Month' contains only valid month abbreviations", {
  expect_true(all(simulated_data$Month %in% valid_Month))  
  # Check that all values in the 'Month' column are valid month abbreviations
})

