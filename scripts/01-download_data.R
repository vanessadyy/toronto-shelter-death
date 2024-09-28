#### Preamble ####
# Purpose:
# Retrieves and saves the "Shelter Death" dataset from Open Data Toronto for analysis.
# Author: Yiyue Deng
# Date: 28 September 2024
# Contact: yiyue.deng@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - Ensure 'opendatatoronto' and 'tidyverse' are installed and loaded.
# - The 'data/raw_data' directory will be created if it doesn't exist.
# Any other information needed?
# - The dataset is saved as 'Deaths_of_Shelter_Residents.csv' for future use.
# - Adjust package ID and resource name to download other datasets.

#### Workspace Setup ####
# Load required libraries
library(opendatatoronto)
library(tidyverse)

#Find data directory
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path),"/../")
setwd(fd)
#### Create Directory for Raw Data ####
# Create the 'data/raw_data' directory if it doesn't exist
if (!dir.exists("data/raw_data")) {
  dir.create("data/raw_data", recursive = TRUE)
}

#### Download Data ####

# get package
package <- show_package("deaths-of-shelter-residents")
package

# get all resources for this package
resources <- list_package_resources("deaths-of-shelter-residents")

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

# load the first datastore resource as a sample
dt <- filter(datastore_resources, row_number()==1) %>% get_resource()

#### Save the Dataset as CSV ####
# Save the downloaded data as a CSV file in the 'data/raw_data' directory
write_csv(dt, "./data/raw_data/Deaths_of_Shelter_Residents.csv")

#### Data Preview ####
# Display the first few rows of the dataset for verification
head(dt)

