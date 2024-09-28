# Toronto Shelter Death Data Analysis

## Overview

This project analyzes the "Deaths of Shelter Residents" dataset from Open Data Toronto. The goal is to explore trends in shelter death in Toronto since 2007, providing support to relative policy makers.

## File Structure

The repo is structured as follows:

- `data/raw_data`: Contains the raw data downloaded from Open Data Toronto.
- `scripts`: Contains R scripts used for simulating, downloading, cleaning, and testing data:
  - `00-simulate_data.R`: Simulates shelter data for testing purposes.
  - `01-download_data.R`: Downloads actual data from Open Data Toronto.
  - `02-data_cleaning.R`: Cleans and processes the downloaded data.
  - `03-test_data.R`: Tests the data for consistency and accuracy.
- `paper`: Contains the Quarto document (`paper.qmd`) used to generate the final PDF report.


## Statement on LLM Usage

Aspects of the code were written with the help of the auto-complete tool, ChatGPT. The entire chat history is available in other/llm_usage/usage.txt.
