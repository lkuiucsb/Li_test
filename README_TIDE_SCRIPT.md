# NOAA Tide Prediction Data Fetcher

This R script fetches and displays tide prediction data from the NOAA Center for Operational Oceanographic Products and Services (CO-OPS) API for the last three days.

## Features

- Fetches real-time tide prediction data from NOAA CO-OPS API
- Displays data for the last 3 days
- Shows tide heights in feet with timestamps
- Provides summary statistics (highest, lowest, average, and standard deviation)
- Includes fallback mock data for demonstration when API is unavailable

## Default Station

**Station ID**: 9411340 (Port Reyes, California)
- **Location**: Port Reyes, CA
- **Coordinates**: Latitude 38.0°, Longitude -122.97°

## Files

1. `noaa_tide_data.R` - Main script that fetches data from NOAA API
2. `noaa_tide_data_demo.R` - Demo version with fallback mock data

## Requirements

The script requires the following R packages:
- `httr` - for HTTP requests to the NOAA API
- `jsonlite` - for parsing JSON responses
- `lubridate` - for date/time manipulation

### Installing Requirements

On Ubuntu/Debian systems:
```bash
sudo apt install r-base r-cran-httr r-cran-jsonlite r-cran-lubridate
```

Or install packages from CRAN within R:
```r
install.packages(c("httr", "jsonlite", "lubridate"))
```

## Usage

### Running the Script

```bash
Rscript noaa_tide_data.R
```

Or for the demo version:
```bash
Rscript noaa_tide_data_demo.R
```

### Sample Output

```
NOAA Tide Prediction Data Fetcher
==================================

Fetching tide prediction data...
Station: 9411340 
Date range: 2024-09-07 to 2024-09-10 
API URL: https://api.tidesandcurrents.noaa.gov/api/prod/datagetter 

=== NOAA Tide Predictions ===
Station: Port Reyes ( 9411340 )
Latitude: 38.0 Longitude: -122.97 
Total predictions: 73 

===  Saturday, September 07, 2024  ===
00:00 - 5.63 ft
03:00 - 6.88 ft
06:00 - 1.99 ft
09:00 - 2.06 ft
12:00 - 5.69 ft
15:00 - 5.82 ft
18:00 - 1.72 ft
21:00 - 1.46 ft

=== Summary ===
Highest tide: 7.43 ft
Lowest tide: 0.72 ft
Average height: 4.03 ft
Standard deviation: 2.15 ft
```

## API Information

The script uses the NOAA CO-OPS API:
- **Base URL**: `https://api.tidesandcurrents.noaa.gov/api/prod/datagetter`
- **Product**: Tide predictions
- **Datum**: MLLW (Mean Lower Low Water)
- **Time Zone**: Local Standard Time/Local Daylight Time
- **Units**: English (feet)
- **Interval**: Hourly

## Customization

You can modify the script to:
- Change the station ID to fetch data for a different location
- Adjust the number of days to fetch (default is 3)
- Change the display format or add additional statistics
- Modify the time interval (hourly is default)

## Error Handling

The script includes robust error handling:
- Network connectivity issues
- Invalid API responses
- Missing data periods
- The demo version automatically falls back to mock data when the API is unavailable

## Notes

- The NOAA API may have rate limits or temporary outages
- Data is provided in local time for the station
- Tide predictions are based on harmonic analysis and may differ from actual observed values
- For real-time observations, use the "observations" product instead of "predictions"

## License

This project is open source. Please check the repository license for details.