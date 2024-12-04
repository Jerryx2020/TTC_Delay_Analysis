#### Preamble ####
# Purpose: Test the cleaned TTC delay data saved as a Parquet file
# Author: Jerry Xia
# Date: December 3, 2024
# Contact: jerry.xia@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Install tidyverse, arrow, and testthat packages:
#   install.packages("tidyverse")
#   install.packages("arrow")
#   install.packages("testthat")
# - Run 03-clean_data.R to generate the Parquet file.



#### Workspace setup ####
library(tidyverse)
library(arrow)
library(testthat)

# Define file path for the Parquet file
parquet_file <- here::here("data", "02-analysis_data", "combined_ttc_delay_data.parquet")

# Check if the Parquet file exists before running tests
if (!file.exists(parquet_file)) {
  stop("The file 'combined_ttc_delay_data.parquet' does not exist. Ensure 03-clean_data.R has been run to generate the file.")
}

# Load the cleaned data
cleaned_data <- read_parquet(parquet_file)



#### Define tests ####

# Test 1: Check that the dataset has the correct columns
test_that("Dataset has required columns", {
  expected_columns <- c("mode", "date", "day_of_week", "bound", "min_delay", "min_gap", "location", "line")
  actual_columns <- colnames(cleaned_data)
  expect_equal(actual_columns, expected_columns)
})

# Test 2: Check that `mode` only contains valid categories
test_that("Mode contains valid categories", {
  valid_modes <- c("Bus", "Streetcar", "Subway")
  expect_true(all(cleaned_data$mode %in% valid_modes))
})

# Test 3: Check that `location` only contains DUNDAS, YORKDALE, or OTHER
test_that("Location contains valid values", {
  valid_locations <- c("DUNDAS", "YORKDALE", "OTHER")
  expect_true(all(cleaned_data$location %in% valid_locations))
})

# Test 4: Check that `line` is only present for streetcars and contains valid values
test_that("Line is valid for Streetcar", {
  streetcar_lines <- c("510", "501", "OTHER")
  streetcar_data <- cleaned_data %>% filter(mode == "Streetcar")
  expect_true(all(streetcar_data$line %in% streetcar_lines))
})

# Test 5: Check that `line` is NA for Bus and Subway modes
test_that("Line is NA for Bus and Subway", {
  non_streetcar_data <- cleaned_data %>% filter(mode != "Streetcar")
  expect_true(all(is.na(non_streetcar_data$line)))
})

# Test 6: Check that `min_delay` and `min_gap` are non-negative numbers
test_that("Min delay and min gap are non-negative", {
  expect_true(all(cleaned_data$min_delay >= 0, na.rm = TRUE))
  expect_true(all(cleaned_data$min_gap >= 0, na.rm = TRUE))
})

# Test 7: Check that dates are in the correct format and range
test_that("Dates are in the correct format and range", {
  expect_true(all(cleaned_data$date >= as.Date("2024-01-01") & cleaned_data$date <= as.Date("2024-10-31")))
})

# Test 8: Check that `bound` contains valid directions
test_that("Bound contains valid directions", {
  valid_directions <- c("North", "South", "East", "West", NA)
  expect_true(all(cleaned_data$bound %in% valid_directions, na.rm = TRUE))
})

# Test 9: Check that `day_of_week` contains valid day names
test_that("Day of week is valid", {
  valid_days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
  expect_true(all(cleaned_data$day_of_week %in% valid_days))
})
