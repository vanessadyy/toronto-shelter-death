#### Workspace Setup ####
library(tidyverse)  # For data manipulation functions
library(janitor)    # For cleaning column names and data

# Set working directory
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/../")
setwd(fd)

#### Create Directory for Cleaned Data ####
if (!dir.exists("data/cleaned_data")) {
  dir.create("data/cleaned_data", recursive = TRUE)
}

#### Load Raw Data ####
dt <- read_csv("/Users/dengyiyue/Desktop/Life Expectancy Data.csv")

#### Data Cleaning and Preparation ####
cleandt <- dt |>
  clean_names() %>%
  # Remove columns with excessive missing values
  select(-c(hepatitis_b, population, income_composition_of_resources)) %>%
  # Handle missing values by filling with the mean (or other strategies)
  mutate(
    life_expectancy = ifelse(is.na(life_expectancy), mean(life_expectancy, na.rm = TRUE), life_expectancy),
    adult_mortality = ifelse(is.na(adult_mortality), mean(adult_mortality, na.rm = TRUE), adult_mortality),
    alcohol = ifelse(is.na(alcohol), mean(alcohol, na.rm = TRUE), alcohol),
    bmi = ifelse(is.na(bmi), mean(bmi, na.rm = TRUE), bmi),
    total_expenditure = ifelse(is.na(total_expenditure), mean(total_expenditure, na.rm = TRUE), total_expenditure),
    schooling = ifelse(is.na(schooling), mean(schooling, na.rm = TRUE), schooling)
  ) %>%
  # Cap outliers to avoid extreme values in key columns
  mutate(
    infant_deaths = pmin(pmax(infant_deaths, quantile(infant_deaths, 0.01)), quantile(infant_deaths, 0.99)),
    gdp = pmin(pmax(gdp, quantile(gdp, 0.01, na.rm = TRUE)), quantile(gdp, 0.99, na.rm = TRUE))
  ) %>%
  # Normalize certain columns
  mutate(
    gdp = (gdp - min(gdp, na.rm = TRUE)) / (max(gdp, na.rm = TRUE) - min(gdp, na.rm = TRUE)),
    percentage_expenditure = (percentage_expenditure - min(percentage_expenditure, na.rm = TRUE)) /
      (max(percentage_expenditure, na.rm = TRUE) - min(percentage_expenditure, na.rm = TRUE))
  ) %>%
  drop_na()  # Remove any rows with missing values after processing

# Summarize and inspect the cleaned data
summary(cleandt)

### Output Clean Data ###
write_csv(cleandt, "./data/cleaned_data/Life_Expectancy_Cleaned_Improved.csv")

