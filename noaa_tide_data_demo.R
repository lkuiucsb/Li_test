#!/usr/bin/env Rscript

# NOAA Tide Prediction Data Fetcher - Demo Version
# Demonstrates tide prediction data display for the last 3 days
# Station: 9411340 (Port Reyes, CA)

# Load required libraries
library(httr)
library(jsonlite)
library(lubridate)

# Function to create mock tide data for demonstration
create_mock_data <- function() {
  # Create 3 days of hourly tide predictions
  start_time <- now() - days(3)
  times <- seq(start_time, now(), by = "hour")
  
  # Generate realistic tide heights (varies between 0 and 8 feet)
  n_points <- length(times)
  heights <- 4 + 3 * sin(2 * pi * seq_along(times) / 12.5) + 
             0.5 * sin(2 * pi * seq_along(times) / 24) +
             rnorm(n_points, 0, 0.1)
  
  # Format times for API format
  formatted_times <- format(times, "%Y-%m-%d %H:%M")
  
  # Create mock API response structure
  mock_data <- list(
    metadata = list(
      id = "9411340",
      name = "Port Reyes",
      lat = "38.0",
      lon = "-122.97"
    ),
    predictions = data.frame(
      t = formatted_times,
      v = round(heights, 2),
      stringsAsFactors = FALSE
    )
  )
  
  return(mock_data)
}

# Function to fetch tide prediction data from NOAA API
fetch_tide_data <- function(station_id = "9411340", days_back = 3, use_mock = FALSE) {
  
  if (use_mock) {
    cat("Using mock data for demonstration purposes...\n\n")
    return(create_mock_data())
  }
  
  # Calculate date range (last 3 days)
  end_date <- Sys.Date()
  start_date <- end_date - days(days_back)
  
  # Format dates for API (YYYYMMDD)
  start_date_str <- format(start_date, "%Y%m%d")
  end_date_str <- format(end_date, "%Y%m%d")
  
  # NOAA CO-OPS API endpoint
  base_url <- "https://api.tidesandcurrents.noaa.gov/api/prod/datagetter"
  
  # API parameters
  params <- list(
    product = "predictions",
    application = "NOS.COOPS.TAC.WL",
    begin_date = start_date_str,
    end_date = end_date_str,
    datum = "MLLW",
    station = station_id,
    time_zone = "lst_ldt",
    units = "english",
    interval = "h",
    format = "json"
  )
  
  # Make API request
  cat("Fetching tide prediction data...\n")
  cat("Station:", station_id, "\n")
  cat("Date range:", start_date, "to", end_date, "\n")
  cat("API URL:", base_url, "\n\n")
  
  tryCatch({
    response <- GET(url = base_url, query = params)
    
    # Check if request was successful
    if (status_code(response) == 200) {
      # Parse JSON response
      data <- fromJSON(content(response, "text", encoding = "UTF-8"))
      
      if (!is.null(data$predictions) && length(data$predictions) > 0) {
        return(data)
      } else {
        cat("No tide prediction data found for the specified period.\n")
        return(NULL)
      }
      
    } else {
      cat("API request failed with status code:", status_code(response), "\n")
      cat("Response:", content(response, "text"), "\n")
      return(NULL)
    }
    
  }, error = function(e) {
    cat("Error fetching data:", e$message, "\n")
    cat("Falling back to mock data for demonstration...\n\n")
    return(create_mock_data())
  })
}

# Function to display tide data in a formatted way
display_tide_data <- function(tide_data) {
  
  if (is.null(tide_data) || is.null(tide_data$predictions)) {
    cat("No data to display.\n")
    return()
  }
  
  predictions <- tide_data$predictions
  
  # Get metadata if available
  if (!is.null(tide_data$metadata)) {
    metadata <- tide_data$metadata
    cat("=== NOAA Tide Predictions ===\n")
    cat("Station:", metadata$name, "(", metadata$id, ")\n")
    cat("Latitude:", metadata$lat, "Longitude:", metadata$lon, "\n")
    cat("Total predictions:", nrow(predictions), "\n\n")
  }
  
  # Convert time to POSIXct for better formatting
  predictions$datetime <- as.POSIXct(predictions$t, format = "%Y-%m-%d %H:%M")
  
  # Display data grouped by day
  predictions$date <- as.Date(predictions$datetime)
  unique_dates <- unique(predictions$date)
  
  for (date in sort(unique_dates)) {
    day_data <- predictions[predictions$date == date, ]
    day_data <- day_data[order(day_data$datetime), ]
    
    cat("=== ", format(as.Date(date), "%A, %B %d, %Y"), " ===\n")
    
    # Show a sample of predictions (every 3 hours to keep output manageable)
    sample_indices <- seq(1, nrow(day_data), by = 3)
    sample_data <- day_data[sample_indices, ]
    
    for (i in 1:nrow(sample_data)) {
      time_str <- format(sample_data$datetime[i], "%H:%M")
      height <- round(as.numeric(sample_data$v[i]), 2)
      cat(sprintf("%s - %s ft\n", time_str, height))
    }
    cat("\n")
  }
  
  # Summary statistics
  heights <- as.numeric(predictions$v)
  cat("=== Summary ===\n")
  cat("Highest tide:", round(max(heights, na.rm = TRUE), 2), "ft\n")
  cat("Lowest tide:", round(min(heights, na.rm = TRUE), 2), "ft\n")
  cat("Average height:", round(mean(heights, na.rm = TRUE), 2), "ft\n")
  cat("Standard deviation:", round(sd(heights, na.rm = TRUE), 2), "ft\n")
}

# Main execution
main <- function() {
  cat("NOAA Tide Prediction Data Fetcher\n")
  cat("==================================\n\n")
  
  # Try to fetch real data, fall back to mock data if needed
  tide_data <- fetch_tide_data()
  
  # Display the data
  if (!is.null(tide_data)) {
    display_tide_data(tide_data)
  } else {
    cat("Failed to fetch tide data. Please check your internet connection and try again.\n")
  }
}

# Run the script if called directly
if (length(commandArgs(trailingOnly = TRUE)) == 0) {
  main()
}