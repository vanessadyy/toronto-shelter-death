#### Preamble ####
# Purpose:
# Retrieves and saves the "Shelter Occupancy & Capacity" dataset from Open Data Toronto for analysis.
# Author: Yiyue Deng
# Date: 19 September 2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - Ensure 'opendatatoronto' and 'tidyverse' are installed and loaded.
# - The 'data/raw_data' directory will be created if it doesn't exist.
# Any other information needed?
# - The dataset is saved as 'toronto_shelters_raw_2023.csv' for future use.
# - Adjust package ID and resource name to download other datasets.


#### Workspace setup ####
# Load required libraries for data retrieval, cleaning, and manipulation.
library(knitr)
library(janitor)
library(tidyverse)
library(opendatatoronto)

#### Download Data ####
# Retrieve the 'Daily Shelter & Overnight Service Occupancy Capacity' dataset from Open Data Toronto.

raw_data <- list_package_resources("21c83b32-d5a8-4106-a54f-010dbe49f6f2") %>%
  filter(name == "daily-shelter-overnight-service-occupancy-capacity-2023.csv") %>%
  get_resource()

#### Save Raw Data ####
# Ensure the raw_data directory exists and save the downloaded data as a CSV file.
output_dir <- "data/raw_data"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

write_csv(raw_data, file = file.path(output_dir, "toronto_shelters_raw_2023.csv"))

#### Data Preview ####
# Display the first few rows of the raw dataset for quick verification.
head(raw_data)
