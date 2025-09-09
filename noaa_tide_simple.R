#!/usr/bin/env Rscript

# Simple NOAA Tide Data Script (without external dependencies)
# Fetches and displays the last 3 days of tide prediction data from NOAA station 9411340
# Author: GitHub Copilot
# Date: 2024

# Function to get last 3 days of tide data using base R
get_noaa_tide_data_simple <- function(station_id = "9411340") {
  
  # Calculate date range for last 3 days
  end_date <- Sys.Date()
  start_date <- end_date - 2  # Changed from 3 to 2 to get exactly 3 days including today
  
  # Format dates for NOAA API (YYYYMMDD)
  begin_date <- format(start_date, "%Y%m%d")
  end_date_formatted <- format(end_date, "%Y%m%d")
  
  # Construct NOAA API URL
  url <- paste0(
    "https://tidesandcurrents.noaa.gov/api/datagetter",
    "?product=predictions",
    "&station=", station_id,
    "&begin_date=", begin_date,
    "&end_date=", end_date_formatted,
    "&datum=MLLW",
    "&time_zone=lst_ldt",
    "&units=english",
    "&format=csv"  # Use CSV format for easier parsing with base R
  )
  
  cat("NOAA Tide Data Retrieval Script\n")
  cat("===============================\n\n")
  cat("Fetching tide data from NOAA...\n")
  cat("Station:", station_id, "\n")
  cat("Date range:", start_date, "to", end_date, "\n")
  cat("API URL:", url, "\n\n")
  
  # Try to fetch data using base R
  tryCatch({
    
    # Use read.csv to fetch data directly from URL
    cat("Attempting to download data...\n")
    
    # Download the CSV data
    data <- read.csv(url, stringsAsFactors = FALSE)
    
    if (nrow(data) > 0) {
      
      # Clean and format the data
      colnames(data) <- c("datetime", "height")
      
      # Convert datetime
      data$datetime <- as.POSIXct(data$datetime, format = "%Y-%m-%d %H:%M")
      data$height <- as.numeric(data$height)
      
      # Remove any rows with missing data
      data <- data[complete.cases(data), ]
      
      cat("Successfully retrieved", nrow(data), "tide predictions\n")
      cat("Data covers:", min(data$datetime), "to", max(data$datetime), "\n\n")
      
      # Display first few rows
      cat("First 10 tide predictions:\n")
      cat("==========================\n")
      print(head(data, 10))
      
      cat("\nLast 10 tide predictions:\n")
      cat("=========================\n")
      print(tail(data, 10))
      
      # Basic statistics
      cat("\nTide Height Statistics (feet):\n")
      cat("==============================\n")
      cat("Minimum:", min(data$height, na.rm = TRUE), "ft\n")
      cat("Maximum:", max(data$height, na.rm = TRUE), "ft\n")
      cat("Mean:", round(mean(data$height, na.rm = TRUE), 2), "ft\n")
      cat("Range:", round(max(data$height, na.rm = TRUE) - min(data$height, na.rm = TRUE), 2), "ft\n")
      
      return(data)
      
    } else {
      cat("Error: No data retrieved from NOAA API\n")
      return(NULL)
    }
    
  }, error = function(e) {
    cat("Error fetching data:", e$message, "\n\n")
    
    # Provide helpful troubleshooting information
    cat("Troubleshooting:\n")
    cat("================\n")
    cat("1. Check internet connection\n")
    cat("2. Verify NOAA servers are accessible\n")
    cat("3. Confirm station ID", station_id, "is valid\n")
    cat("4. Check if firewall is blocking the request\n\n")
    
    # Create sample data for demonstration
    cat("Creating sample data for demonstration...\n")
    return(create_sample_data())
  })
}

# Function to create sample tide data for demonstration
create_sample_data <- function() {
  
  # Create sample data covering 3 days
  start_time <- Sys.time() - 3*24*3600  # 3 days ago
  
  # Generate hourly data points for 3 days (72 hours)
  times <- seq(start_time, by = "hour", length.out = 72)
  
  # Create realistic tide pattern (2 high tides and 2 low tides per day)
  # Using a sine wave with 12.5 hour period (lunar semi-diurnal tide)
  hours_since_start <- as.numeric(difftime(times, start_time, units = "hours"))
  tide_cycle <- 12.5  # hours per tide cycle
  
  # Generate realistic tide heights (typical range for many locations)
  base_height <- 3.0  # feet (mean tide level)
  amplitude <- 2.5    # feet (tide range)
  
  # Add some randomness to make it more realistic
  set.seed(42)  # For reproducible results
  heights <- base_height + amplitude * sin(2 * pi * hours_since_start / tide_cycle) + 
             rnorm(length(times), 0, 0.1)  # Small random variation
  
  # Create data frame
  sample_data <- data.frame(
    datetime = times,
    height = round(heights, 2)
  )
  
  cat("\nSample tide data created (72 hours of data)\n")
  cat("===========================================\n")
  cat("Note: This is simulated data for demonstration purposes\n")
  cat("Actual NOAA data would be fetched from the API when network is available\n\n")
  
  return(sample_data)
}

# Function to create a simple plot of tide data
plot_tide_data <- function(tide_data) {
  if (is.null(tide_data) || nrow(tide_data) == 0) {
    cat("No data available for plotting\n")
    return()
  }
  
  tryCatch({
    
    # Create the plot
    plot(tide_data$datetime, tide_data$height,
         type = "l",
         main = "Tide Predictions - Last 3 Days",
         xlab = "Date/Time",
         ylab = "Height (feet)",
         col = "blue",
         lwd = 2)
    
    # Add grid for better readability
    grid()
    
    # Add points for high and low tides
    points(tide_data$datetime, tide_data$height, 
           pch = 20, col = "red", cex = 0.5)
    
    cat("Tide plot created successfully\n")
    
    # Save plot to file
    png("tide_plot.png", width = 800, height = 600)
    plot(tide_data$datetime, tide_data$height,
         type = "l",
         main = "Tide Predictions - Last 3 Days",
         xlab = "Date/Time",
         ylab = "Height (feet)",
         col = "blue",
         lwd = 2)
    grid()
    points(tide_data$datetime, tide_data$height, 
           pch = 20, col = "red", cex = 0.5)
    dev.off()
    
    cat("Plot saved as 'tide_plot.png'\n")
    
  }, error = function(e) {
    cat("Could not create plot:", e$message, "\n")
  })
}

# Main execution function
main <- function() {
  # Get tide data
  tide_data <- get_noaa_tide_data_simple()
  
  # Create plot if data was retrieved successfully
  if (!is.null(tide_data)) {
    cat("\nCreating tide plot...\n")
    plot_tide_data(tide_data)
  }
  
  cat("\nScript completed.\n")
  cat("==================\n")
  cat("To run this script manually: Rscript noaa_tide_simple.R\n")
  cat("For help or modifications, edit the script file.\n")
}

# Run main function if script is executed directly
if (!interactive()) {
  main()
}