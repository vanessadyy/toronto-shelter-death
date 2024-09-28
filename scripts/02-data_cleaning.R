#### Preamble ####
# Purpose:
# Clean shelter death data
# Output cleaned data for further analysis.
# Author: Yiyue Deng
# Date: 28 September 2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - Install and load necessary libraries: tidyverse

# Any other information needed?
# - This script simulates organizational and numerical data for shelters over one year (365 days).
# - The generated data is saved as CSV files in the 'data/raw_data/' folder.
# - Ensure that the simulated data files will be used in subsequent analysis and testing scripts.

#### Workspace Setup ####
library(tidyverse)  # Load 'tidyverse' for data manipulation functions
library(janitor)    # Load 'janitor' to help with cleaning column names and data

# Set data directory
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/../")  
# Create a path to the project root folder by combining the current script path with '../'
setwd(fd)  # Set the working directory to the root folder

#### Create Directory for Cleaned Data ####
# Create the 'data/cleaned_data' directory if it doesn't exist
if (!dir.exists("data/cleaned_data")) {  
  # Check if the 'cleaned_data' directory exists
  dir.create("data/cleaned_data", recursive = TRUE)  
  # If it doesn't exist, create the 'cleaned_data' directory, including any necessary parent directories
}

#### Load Raw Data ####
# Load the raw CSV file
dt <- read_csv("./data/raw_data/Deaths_of_Shelter_Residents.csv")  
# Read the raw data from the 'Deaths_of_Shelter_Residents.csv' file for cleaning and analysis

#### Data Cleaning and Preparation ####
cleandt <- dt |>
  clean_names() %>%  # Standardize column names (e.g., make them lowercase and replace spaces with underscores)
  rename(
    Year = year,  # Rename 'year' to 'Year' for consistency
    Month = month,  # Rename 'month' to 'Month'
    Total_Death = total_decedents,  # Rename 'total_decedents' to 'Total_Death'
    Male = male,  # Rename 'male' to 'Male'
    Female = female,  # Rename 'female' to 'Female'
    OtherGender = transgender_non_binary_two_spirit  # Rename 'transgender_non_binary_two_spirit' to 'OtherGender'
  ) %>%
  mutate(
    Time = ymd(parse_date_time(paste(Month, Year), orders = "b Y")),  
    # Create a new 'Time' variable by combining 'Month' and 'Year' into a date (format: YYYY-MM-DD)
    OtherGender = as.integer(na_if(OtherGender, "n/a"))  
    # Convert 'OtherGender' to integer and replace "n/a" values with NA (missing values)
  ) %>%
  select(-c(id))  # Remove the 'id' column as it is not needed for further analysis

# Summarize and inspect the cleaned data
summary(cleandt)  
# Display a summary of the cleaned data, including statistics for each variable

cleandt <- cleandt %>% select(-OtherGender)  
# Drop the 'OtherGender' column, as most values are missing, making it less useful for analysis

### Output clean data
write_csv(cleandt, "./data/cleaned_data/Deaths_of_Shelter_Residents_Cleaned.csv")  
# Save the cleaned data as a CSV file in the 'data/cleaned_data' directory for further analysis
