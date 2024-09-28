#### Preamble ####
# Purpose: 
# Ensure all values from simulated data in reasonable ranges.
# Author: Yiyue Deng 
# Date: 28 September 2024 
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - Install and load tidyverse and testthat library
# - Run 00-simulate_data.R first
# Any other information needed?
# - This script performs basic validation checks; further statistical analysis may be required later.

#### Setup ####
library(tidyverse)
library(testthat)

#Set data directory
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/../")
setwd(fd)

#### Load the Simulated Data ####
simulated_data <- read_csv("./data/raw_data/simulated.csv", show_col_types = FALSE)

# Column name validation
required_columns <- c("Month", "Year", "Male", "Female","Total_Death","Time")
missing_columns <- setdiff(required_columns, colnames(simulated_data))
ifelse(length(missing_columns) > 0, paste("Missing required columns:", missing_columns),paste("Column names matched"))

### Simulated data used a different name for "Time"
### Correct it and move on
simulated_data <- simulated_data %>% rename(Time=date)

# Column name recheck
missing_columns <- setdiff(required_columns, colnames(simulated_data))
ifelse(length(missing_columns) > 0, paste("Missing required columns:", missing_columns),paste("Column names matched"))

#### Column Type Validation ####
# Ensure the required columns are integers
simulated_data <- simulated_data %>% 
  mutate(
    across(c(Year, Total_Death  , Male , Female,OtherGender ), as.integer),
    Time = as.Date(Time))

# Check ranges of integer variables
summary(simulated_data)

# Drop OtherGender due to too much missing values and as it is not included in the cleaned data
simulated_data <- simulated_data %>% select(-OtherGender)

# Test that there are no missing values in the dataset
test_that("no missing values in dataset", {
  expect_true(all(!is.na(simulated_data)))
})

# Test that 'Month' contains only valid month abbreviations
valid_Month <- month.abb[1:12]
test_that("'Month' contains only valid month abbreviations", {
  expect_true(all(simulated_data$Month %in% valid_Month))
})

