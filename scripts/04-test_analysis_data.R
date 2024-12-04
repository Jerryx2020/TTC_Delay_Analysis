#### Preamble ####
# Purpose: Test the validity and structure of the cleaned TTC delay data
# Author: Jerry Xia
# Date: December 3, 2024
# Contact: jerry.xia@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - The `03-clean_data.R` script must have been run to generate cleaned data files.
# - Install the `testthat`, `tidyverse`, and `here` packages.



#### Workspace setup ####
library(testthat)
library(tidyverse)
library(here)

# Define file paths
bus_path <- here("data", "02-analysis_data", "cleaned_bus.csv")
subway_path <- here("data", "02-analysis_data", "cleaned_subway.csv")
streetcar_path <- here("data", "02-analysis_data", "cleaned_streetcar.csv")



#### Check if files exist ####
test_that("Cleaned data files exist", {
  expect_true(file.exists(bus_path), "Bus cleaned data file does not exist.")
  expect_true(file.exists(subway_path), "Subway cleaned data file does not exist.")
  expect_true(file.exists(streetcar_path), "Streetcar cleaned data file does not exist.")
})

# Load cleaned data
cleaned_bus <- read_csv(bus_path)
cleaned_subway <- read_csv(subway_path)
cleaned_streetcar <- read_csv(streetcar_path)



#### Define tests ####

# Test 1: Check that all datasets have required columns
test_that("Cleaned datasets have correct columns", {
  expected_bus_columns <- c("mode", "date", "day_of_week", "bound", "min_delay", "min_gap", "location")
  expect_equal(colnames(cleaned_bus), expected_bus_columns)
  
  expected_subway_columns <- c("mode", "date", "day_of_week", "bound", "min_delay", "min_gap", "location")
  expect_equal(colnames(cleaned_subway), expected_subway_columns)
  
  expected_streetcar_columns <- c("mode", "date", "day_of_week", "bound", "min_delay", "min_gap", "location", "line")
  expect_equal(colnames(cleaned_streetcar), expected_streetcar_columns)
})

# Test 2: Check that `mode` has the correct values
test_that("Mode contains valid values", {
  expect_true(all(cleaned_bus$mode == "Bus"))
  expect_true(all(cleaned_subway$mode == "Subway"))
  expect_true(all(cleaned_streetcar$mode == "Streetcar"))
})

# Test 3: Check that `location` contains only valid categories
test_that("Location contains valid values", {
  valid_locations <- c("DUNDAS", "YORKDALE", "OTHER")
  expect_true(all(cleaned_bus$location %in% valid_locations))
  expect_true(all(cleaned_subway$location %in% valid_locations))
  expect_true(all(cleaned_streetcar$location %in% valid_locations))
})

# Test 4: Check that `line` is valid for streetcars
test_that("Streetcar line contains valid values", {
  valid_lines <- c("510", "501", "OTHER")
  expect_true(all(cleaned_streetcar$line %in% valid_lines))
})

# Test 5: Check that `min_delay` and `min_gap` are non-negative
test_that("Min delay and min gap are non-negative", {
  expect_true(all(cleaned_bus$min_delay >= 0))
  expect_true(all(cleaned_bus$min_gap >= 0))
  
  expect_true(all(cleaned_subway$min_delay >= 0))
  expect_true(all(cleaned_subway$min_gap >= 0))
  
  expect_true(all(cleaned_streetcar$min_delay >= 0))
  expect_true(all(cleaned_streetcar$min_gap >= 0))
})

# Test 6: Check that `date` is in proper format and within 2024
test_that("Dates are properly formatted and within range", {
  min_date <- as.Date("2024-01-01")
  max_date <- as.Date("2024-10-31")
  
  expect_true(all(cleaned_bus$date >= min_date & cleaned_bus$date <= max_date))
  expect_true(all(cleaned_subway$date >= min_date & cleaned_subway$date <= max_date))
  expect_true(all(cleaned_streetcar$date >= min_date & cleaned_streetcar$date <= max_date))
})

# Test 7: Check that `day_of_week` contains valid day names
test_that("Day of week is valid", {
  valid_days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
  expect_true(all(cleaned_bus$day_of_week %in% valid_days))
  expect_true(all(cleaned_subway$day_of_week %in% valid_days))
  expect_true(all(cleaned_streetcar$day_of_week %in% valid_days))
})



#### Run all tests ####
message("All tests completed successfully.")
