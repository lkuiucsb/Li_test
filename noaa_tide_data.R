#!/usr/bin/env Rscript

# NOAA Tide Data Script
# Fetches and displays the last 3 days of tide prediction data from NOAA station 9411340
# Author: GitHub Copilot
# Date: 2024

# Load required libraries
suppressPackageStartupMessages({
  if (!require(httr, quietly = TRUE)) {
    cat("Installing httr package...\n")
    install.packages("httr", repos = "https://cran.rstudio.com/")
    library(httr)
  }
  
  if (!require(jsonlite, quietly = TRUE)) {
    cat("Installing jsonlite package...\n")
    install.packages("jsonlite", repos = "https://cran.rstudio.com/")
    library(jsonlite)
  }
})

# Function to get last 3 days of tide data
get_noaa_tide_data <- function(station_id = "9411340") {
  
  # Calculate date range for last 3 days
  end_date <- Sys.Date()
  start_date <- end_date - 3
  
  # Format dates for NOAA API (YYYYMMDD)
  begin_date <- format(start_date, "%Y%m%d")
  end_date_formatted <- format(end_date, "%Y%m%d")
  
  # Construct NOAA API URL
  base_url <- "https://tidesandcurrents.noaa.gov/api/datagetter"
  
  # API parameters
  params <- list(
    product = "predictions",
    station = station_id,
    begin_date = begin_date,
    end_date = end_date_formatted,
    datum = "MLLW",  # Mean Lower Low Water
    time_zone = "lst_ldt",  # Local Standard/Daylight Time
    units = "english",  # feet and knots
    format = "json"
  )
  
  # Build URL with parameters
  url <- modify_url(base_url, query = params)
  
  cat("Fetching tide data from NOAA...\n")
  cat("Station:", station_id, "\n")
  cat("Date range:", start_date, "to", end_date, "\n")
  cat("API URL:", url, "\n\n")
  
  # Make API request with error handling
  tryCatch({
    response <- GET(url, timeout(30))
    
    # Check if request was successful
    if (status_code(response) == 200) {
      
      # Parse JSON response
      content_text <- content(response, "text", encoding = "UTF-8")
      data <- fromJSON(content_text)
      
      # Check if data contains predictions
      if ("predictions" %in% names(data)) {
        predictions <- data$predictions
        
        # Convert to data frame and format
        df <- as.data.frame(predictions)
        
        # Convert time to POSIXct for better handling
        df$datetime <- as.POSIXct(df$t, format = "%Y-%m-%d %H:%M")
        df$height <- as.numeric(df$v)
        
        # Display summary
        cat("Successfully retrieved", nrow(df), "tide predictions\n")
        cat("Data covers:", min(df$datetime), "to", max(df$datetime), "\n\n")
        
        # Display first few rows
        cat("First 10 tide predictions:\n")
        cat("========================\n")
        print(head(df[c("datetime", "height")], 10))
        
        cat("\nLast 10 tide predictions:\n")
        cat("=========================\n")
        print(tail(df[c("datetime", "height")], 10))
        
        # Basic statistics
        cat("\nTide Height Statistics (feet):\n")
        cat("==============================\n")
        cat("Minimum:", min(df$height, na.rm = TRUE), "ft\n")
        cat("Maximum:", max(df$height, na.rm = TRUE), "ft\n")
        cat("Mean:", round(mean(df$height, na.rm = TRUE), 2), "ft\n")
        cat("Range:", round(max(df$height, na.rm = TRUE) - min(df$height, na.rm = TRUE), 2), "ft\n")
        
        return(df)
        
      } else {
        cat("Error: No prediction data found in response\n")
        if ("error" %in% names(data)) {
          cat("API Error:", data$error$message, "\n")
        }
        return(NULL)
      }
      
    } else {
      cat("HTTP Error:", status_code(response), "\n")
      cat("Response:", content(response, "text"), "\n")
      return(NULL)
    }
    
  }, error = function(e) {
    cat("Network Error:", e$message, "\n")
    cat("This could be due to:\n")
    cat("- No internet connection\n")
    cat("- NOAA servers temporarily unavailable\n")
    cat("- Firewall blocking the request\n")
    cat("\nPlease check your connection and try again.\n")
    return(NULL)
  })
}

# Function to create a simple plot of tide data (if plotting packages are available)
plot_tide_data <- function(tide_data) {
  if (is.null(tide_data) || nrow(tide_data) == 0) {
    cat("No data available for plotting\n")
    return()
  }
  
  tryCatch({
    # Try to use base R plot
    plot(tide_data$datetime, tide_data$height,
         type = "l",
         main = "Tide Predictions - Last 3 Days",
         xlab = "Date/Time",
         ylab = "Height (feet)",
         col = "blue")
    
    # Add grid
    grid()
    
    cat("\nTide plot created successfully\n")
    
  }, error = function(e) {
    cat("Could not create plot:", e$message, "\n")
  })
}

# Main execution
main <- function() {
  cat("NOAA Tide Data Retrieval Script\n")
  cat("===============================\n\n")
  
  # Get tide data
  tide_data <- get_noaa_tide_data()
  
  # Create plot if data was retrieved successfully
  if (!is.null(tide_data)) {
    cat("\nCreating tide plot...\n")
    plot_tide_data(tide_data)
  }
  
  cat("\nScript completed.\n")
}

# Run main function if script is executed directly
if (!interactive()) {
  main()
}