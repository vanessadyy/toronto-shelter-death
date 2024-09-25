#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto
# Author: Yiyue Deng
# Date: 19 September 2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None


#### Workspace setup ####
# Load required libraries for the project.
# 'knitr' is used for report generation, 'janitor' helps in data cleaning,
# 'opendatatoronto' retrieves data from Open Data Toronto, 
# and 'tidyverse' is used for data manipulation.

library(knitr)
library(janitor)
library(tidyverse)
library(opendatatoronto)

#### Download Data ####
# Acquire data from Open Data Toronto using the package ID.
# This corresponds to the 'Daily Shelter & Overnight Service Occupancy Capacity' dataset.

# List and filter the resources to get the required data
raw_data <- list_package_resources("21c83b32-d5a8-4106-a54f-010dbe49f6f2") %>%
  filter(name == "daily-shelter-overnight-service-occupancy-capacity-2023.csv") %>%
  get_resource()

#### Save Raw Data ####
# Save the acquired raw data into the raw_data directory.
# Ensure the directory exists before writing the file.
dir.create("~/Toronto-Shelter-Research/data/raw_data", recursive = TRUE, showWarnings = FALSE)

write_csv(
  x = raw_data,
  file = "~/Toronto-Shelter-Research/data/raw_data/toronto_shelters_raw_2023.csv"
)

#### Data Preview ####
# Display the first few rows of the raw dataset for verification.
head(raw_data)



