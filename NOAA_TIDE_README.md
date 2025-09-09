# NOAA Tide Data Script

This repository contains R scripts to fetch and display tide prediction data from NOAA (National Oceanic and Atmospheric Administration) for the last 3 days.

## Features

- Fetches tide predictions from NOAA Tides and Currents API
- Displays data for the last 3 days 
- Station ID: 9411340 (configurable)
- Generates a plot visualization
- Handles network errors gracefully with sample data fallback

## Files

- `noaa_tide_simple.R` - Main script using only base R (recommended)
- `noaa_tide_data.R` - Enhanced script with additional packages (requires httr, jsonlite)
- `tide_plot.png` - Generated plot of tide predictions

## Usage

### Prerequisites

- R (version 4.0 or higher)
- Internet connection (for live data)

### Running the Script

```bash
# Make script executable
chmod +x noaa_tide_simple.R

# Run the script
Rscript noaa_tide_simple.R
```

Or from within R:
```r
source("noaa_tide_simple.R")
```

### Sample Output

The script will display:
1. First 10 tide predictions
2. Last 10 tide predictions  
3. Statistical summary (min, max, mean, range)
4. Generated plot saved as 'tide_plot.png'

Example output:
```
NOAA Tide Data Retrieval Script
===============================

Fetching tide data from NOAA...
Station: 9411340 
Date range: 2024-09-06 to 2024-09-09

Successfully retrieved 72 tide predictions
Data covers: 2024-09-06 12:00:00 to 2024-09-09 11:00:00

First 10 tide predictions:
==========================
    datetime height
1 2024-09-06 12:00:00   4.2
2 2024-09-06 13:00:00   3.8
...

Tide Height Statistics (feet):
==============================
Minimum: 0.5 ft
Maximum: 6.8 ft
Mean: 3.65 ft
Range: 6.3 ft
```

## NOAA API Details

- **Endpoint**: https://tidesandcurrents.noaa.gov/api/datagetter
- **Station**: 9411340 (Point Reyes, CA)
- **Product**: predictions (tide predictions)
- **Datum**: MLLW (Mean Lower Low Water)
- **Time Zone**: lst_ldt (Local Standard/Daylight Time)
- **Units**: english (feet)
- **Format**: CSV for base R compatibility

## Customization

To use a different NOAA station:
1. Find your station ID at: https://tidesandcurrents.noaa.gov/
2. Modify the `station_id` parameter in the script
3. Run the script

Example for different station:
```r
tide_data <- get_noaa_tide_data_simple("8729840")  # Virginia Beach, VA
```

## Error Handling

If the NOAA API is unavailable, the script will:
1. Display troubleshooting information
2. Generate sample tide data for demonstration
3. Create a plot using the sample data

## Network Issues

If you encounter network connectivity issues:
- Check your internet connection
- Verify NOAA servers are accessible
- Check firewall settings
- The script will fall back to sample data for testing

## Contributing

Feel free to enhance this script by:
- Adding more visualization options
- Supporting multiple stations
- Adding data export functionality
- Improving error handling

## References

- [NOAA Tides and Currents API](https://tidesandcurrents.noaa.gov/api/)
- [NOAA Station Finder](https://tidesandcurrents.noaa.gov/)