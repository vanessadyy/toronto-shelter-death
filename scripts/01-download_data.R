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

#### Workspace Setup ####
# Load required libraries
library(opendatatoronto)
library(tidyverse)

#### Create Directory for Raw Data ####
# Create the 'data/raw_data' directory if it doesn't exist
if (!dir.exists("data/raw_data")) {
  dir.create("data/raw_data", recursive = TRUE)
}

#### Download Data ####
# Search for the dataset package by name or ID
package_id <- "21c83b32-d5a8-4106-a54f-010dbe49f6f2"  # Package ID for the dataset
resource_name <- "daily-shelter-overnight-service-occupancy-capacity-2023.csv"  # Resource name

# Retrieve and filter resources for the specified dataset
resources <- list_package_resources(package_id)
resource <- resources %>%
  filter(name == resource_name) %>%
  get_resource()

#### Save the Dataset as CSV ####
# Save the downloaded data as a CSV file in the 'data/raw_data' directory
output_file <- "data/raw_data/toronto_shelters_raw_2023.csv"
write_csv(resource, file = output_file)

#### Data Preview ####
# Display the first few rows of the dataset for verification
head(resource)
