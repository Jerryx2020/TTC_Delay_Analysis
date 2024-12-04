#### Preamble ####
# Purpose: Test the validity and structure of the simulated TTC delay data
# Author: Jerry Xia
# Date: 3 December 2024
# Contact: Jerry.xia@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Install tidyverse and testthat packages before running
# - Ran 00-simulate_data.R



#### Workspace setup ####
library(tidyverse)
library(testthat)

# Load the simulated dataset
simulated_data <- read_csv("data/00-simulated_data/simulated_ttc_delay_data_focus.csv")

# Check if file exists before running tests
if (!file.exists(file_path)) {
  stop("The file 'simulated_ttc_delay_data_focus.csvv' does not exist. Make sure to run 00-simulate_data.R to generate this file")
}

#### Define tests ####

# Test 1: Check that the dataset has the correct columns
test_that("Dataset has required columns", {
  expected_columns <- c("mode", "date", "day_of_week", "bound", "min_delay", "min_gap", "location", "line")
  actual_columns <- colnames(simulated_data)
  expect_equal(actual_columns, expected_columns)
})

# Test 2: Check that `mode` only contains valid categories
test_that("Mode contains valid categories", {
  valid_modes <- c("Bus", "Streetcar", "Subway")
  expect_true(all(simulated_data$mode %in% valid_modes))
})

# Test 3: Check that `location` only contains DUNDAS, YORKDALE, or OTHER
test_that("Location contains valid values", {
  valid_locations <- c("DUNDAS", "YORKDALE", "OTHER")
  expect_true(all(simulated_data$location %in% valid_locations))
})

# Test 4: Check that `line` is only present for streetcars and contains valid values
test_that("Line is valid for Streetcar", {
  streetcar_lines <- c("510", "501", "OTHER")
  streetcar_data <- simulated_data %>% filter(mode == "Streetcar")
  expect_true(all(streetcar_data$line %in% streetcar_lines))
})

# Test 5: Check that `line` is NA for Bus and Subway modes
test_that("Line is NA for Bus and Subway", {
  non_streetcar_data <- simulated_data %>% filter(mode != "Streetcar")
  expect_true(all(is.na(non_streetcar_data$line)))
})

# Test 6: Check that `min_delay` and `min_gap` are non-negative numbers
test_that("Min delay and min gap are non-negative", {
  expect_true(all(simulated_data$min_delay >= 0))
  expect_true(all(simulated_data$min_gap >= 0))
})

# Test 7: Check that dates are within the expected range in 2024
test_that("Dates are within range", {
  min_date <- as.Date("2024-01-01")
  max_date <- as.Date("2024-10-31")
  expect_true(all(simulated_data$date >= min_date & simulated_data$date <= max_date))
})

# Test 8: Check that `bound` contains valid directions
test_that("Bound contains valid directions", {
  valid_directions <- c("North", "South", "East", "West")
  expect_true(all(simulated_data$bound %in% valid_directions))
})

# Test 9: Check that `day_of_week` contains valid day names
test_that("Day of week is valid", {
  valid_days <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
  expect_true(all(simulated_data$day_of_week %in% valid_days))
})
