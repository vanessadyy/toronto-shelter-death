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
library(opendatatoronto)  # Load 'opendatatoronto' for accessing Open Data Toronto datasets
library(tidyverse)        # Load 'tidyverse' for data manipulation and handling

# Find data directory
fd <- paste0(dirname(rstudioapi::getActiveDocumentContext()$path), "/../")  
# Construct the path to the root folder by combining the current script directory with "../"
setwd(fd)  # Set the working directory to the root folder

#### Create Directory for Raw Data ####
# Create the 'data/raw_data' directory if it doesn't exist
if (!dir.exists("data/raw_data")) {  
  # Check if the directory 'data/raw_data' exists
  dir.create("data/raw_data", recursive = TRUE)  
  # If it doesn't exist, create the directory including any necessary parent directories
}

#### Download Data ####

# get package
package <- show_package("deaths-of-shelter-residents")  
# Retrieve metadata for the "deaths-of-shelter-residents" dataset from Open Data Toronto
package  # Display the metadata

# get all resources for this package
resources <- list_package_resources("deaths-of-shelter-residents")  
# Fetch all available resources (files) linked to the package

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
datastore_resources <- filter(resources, tolower(format) %in% c("csv", "geojson"))  
# Filter the resources to keep only the ones in 'CSV' or 'GeoJSON' format, which are used for data storage

# load the first datastore resource as a sample
dt <- filter(datastore_resources, row_number() == 1) %>% get_resource()  
# Select the first datastore resource (usually the primary dataset) and download it using 'get_resource()'

#### Save the Dataset as CSV ####
# Save the downloaded data as a CSV file in the 'data/raw_data' directory
write_csv(dt, "./data/raw_data/Deaths_of_Shelter_Residents.csv")  
# Write the dataset to a CSV file for future analysis, saving it in the 'data/raw_data' directory

#### Data Preview ####
# Display the first few rows of the dataset for verification
head(dt)  # Preview the first few rows of the downloaded dataset to confirm it was loaded correctly
