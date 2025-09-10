# Li_test

This repository contains code and data for analyzing bird abundance and habitat characteristics across multiple years and locations.

## Repository Structure

- **script/analysis.R**  
  This R script reads and summarizes bird survey data from the `data/density.csv` file.  
  - Uses the `tidyverse` library for data manipulation.
  - Loads the data with `read.csv`.
  - Provides summary statistics and displays the first few rows for initial exploration.

- **data/density.csv**  
  This CSV file contains bird density data with the following columns:
  - `Species`: Bird species code (e.g., ACWO, ALHU, AMCR, etc.)
  - `Year`: Survey year (2015–2021)
  - `Station`: Survey station identifier (e.g., SP 1, SP 2, ...)
  - `Abundance`: Observed abundance (mostly 0s, some fractional values)
  - `GV_fraction`: Fractional habitat value associated with each observation

## How to Use

1. Place the `density.csv` file in the `data/` directory.
2. Run the `analysis.R` script from the `script/` directory using R.
   - The script will load the data, provide summary statistics, and display the first rows.
   - You can further modify the script to explore trends by species, year, or station.

## Example Data

A snippet from `density.csv`:

```
"","Species","Year","Station","Abundance","GV_fraction"
"1","ACWO",2015,"SP 1",0,0.472247632841269
"2","ACWO",2016,"SP 1",0,0.425146870315075
... 
```

## Purpose

This repository is designed for testing data analysis workflows, specifically for working with ecological survey data from NOAA and generating summary tables and figures.

Feel free to extend the analysis or adapt the scripts to your specific research needs!