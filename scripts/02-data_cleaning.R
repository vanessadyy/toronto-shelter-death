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
library(tidyverse)
library(janitor)

#Set data directory
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/../")
setwd(fd)
#### Create Directory for Cleaned Data ####
# Create the 'data/raw_data' directory if it doesn't exist
if (!dir.exists("data/cleaned_data")) {
  dir.create("data/cleaned_data", recursive = TRUE)
}

#### Load Raw Data ####
# Load the raw CSV file
dt <- read_csv("./data/raw_data/Deaths_of_Shelter_Residents.csv")

#### Data Cleaning and Preparation ####

cleandt <- dt |> clean_names() %>%
  rename(
    Year=year,
    Month=month,
    Total_Death=total_decedents,
    Male=male,
    Female=female,
    OtherGender=transgender_non_binary_two_spirit
  ) %>%
  mutate(
    Time = ymd(parse_date_time(paste(Month,Year),orders="b Y")),
    OtherGender = as.integer(na_if(OtherGender,"n/a")) #Correct coding of missing values
  ) %>%   select(-c(id))


summary(cleandt)
cleandt <- cleandt %>% select(-OtherGender) # Drop variable of other gender deaths as most of them are missing values

### Output clean data
write_csv(cleandt,  "./data/cleaned_data/Deaths_of_Shelter_Residents_Cleaned.csv")

