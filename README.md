# Starter folder

# Toronto Shelter Utilization Data Analysis

## Overview

This project analyzes the "Daily Shelter & Overnight Service Occupancy Capacity" dataset from Open Data Toronto. The goal is to explore trends in shelter occupancy and capacity throughout 2023, providing insights into shelter utilization in the city.

## File Structure

The repo is structured as follows:

- `data/raw_data`: Contains the raw data downloaded from Open Data Toronto.
- `scripts`: Contains R scripts used for simulating, downloading, cleaning, and testing data:
  - `00-simulate_data.R`: Simulates shelter data for testing purposes.
  - `01-download_data.R`: Downloads actual data from Open Data Toronto.
  - `02-data_cleaning.R`: Cleans and processes the downloaded data.
  - `03-test_data.R`: Tests the data for consistency and accuracy.
- `paper`: Contains the Quarto document (`paper.qmd`) used to generate the final PDF report.

## Instructions

1. Ensure the following R packages are installed: `tidyverse`, `opendatatoronto`, `janitor`, and `knitr`.
2. Run the scripts in sequence:
   - `00-simulate_data.R` for simulated data.
   - `01-download_data.R` to download the actual data.
   - `02-data_cleaning.R` for data cleaning.
   - `03-test_data.R` for data integrity tests.
3. Render the `paper.qmd` file using Quarto to generate the final PDF report.

## Statement on LLM Usage

No AI tools were used in the creation of this project. All code and documentation were manually written by the author.

## Additional Notes

- The dataset is saved as `toronto_shelters_raw_2023.csv` in the `data/raw_data` folder.
- The project is fully reproducible, and no manual data downloads are required.
