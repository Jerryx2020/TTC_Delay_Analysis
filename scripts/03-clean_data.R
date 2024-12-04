#### Preamble ####
# Purpose: Clean the raw TTC delay data and combine them into one dataset
# Author: Jerry Xia
# Date: December 3, 2024
# Contact: jerry.xia@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Raw data files must be present in `data/01-raw_data` directory.
# - Run `02-download_data.R` first to ensure the data exists.
# - Install `arrow` package for saving Parquet files:
#   install.packages("arrow")



#### Workspace setup ####
library(tidyverse)
library(here)
library(arrow)

# Define raw and processed data directories
raw_data_dir <- here("data", "01-raw_data")
processed_data_dir <- here("data", "02-analysis_data")



#### Read raw data ####

# Load raw datasets
bus_data <- read_csv(file.path(raw_data_dir, "raw_data_bus.csv"))
subway_data <- read_csv(file.path(raw_data_dir, "raw_data_subway.csv"))
streetcar_data <- read_csv(file.path(raw_data_dir, "raw_data_streetcar.csv"))



#### Clean Bus Data ####

cleaned_bus <- bus_data %>%
  mutate(
    mode = "Bus",
    date = as.Date(Date, format = "%d-%m-%Y"), # Standardize date format
    day_of_week = weekdays(date),
    bound = case_when(
      Direction %in% c("N", "North") ~ "North",
      Direction %in% c("S", "South") ~ "South",
      Direction %in% c("E", "East") ~ "East",
      Direction %in% c("W", "West") ~ "West",
      TRUE ~ NA_character_  # Keep only valid directions or set as NA
    ),
    min_delay = `Min Delay`,
    min_gap = `Min Gap`,
    location = case_when(
      str_detect(Location, "DUNDAS") ~ "DUNDAS",
      str_detect(Location, "YORKDALE") ~ "YORKDALE",
      TRUE ~ "OTHER"
    ),
    line = NA_character_ # No `line` for buses
  ) %>%
  select(mode, date, day_of_week, bound, min_delay, min_gap, location, line)



#### Clean Subway Data ####

cleaned_subway <- subway_data %>%
  mutate(
    mode = "Subway",
    date = as.Date(Date, format = "%Y/%m/%d"), # Standardize date format
    day_of_week = weekdays(date),
    bound = case_when(
      Bound %in% c("N", "North") ~ "North",
      Bound %in% c("S", "South") ~ "South",
      Bound %in% c("E", "East") ~ "East",
      Bound %in% c("W", "West") ~ "West",
      TRUE ~ NA_character_  # Keep only valid directions or set as NA
    ),
    min_delay = `Min Delay`,
    min_gap = `Min Gap`,
    location = case_when(
      str_detect(Station, "DUNDAS") ~ "DUNDAS",
      str_detect(Station, "YORKDALE") ~ "YORKDALE",
      TRUE ~ "OTHER"
    ),
    line = NA_character_ # No `line` for subways
  ) %>%
  select(mode, date, day_of_week, bound, min_delay, min_gap, location, line)



#### Clean Streetcar Data ####

cleaned_streetcar <- streetcar_data %>%
  mutate(
    mode = "Streetcar",
    date = as.Date(Date, format = "%d-%m-%Y"), # Standardize date format
    day_of_week = weekdays(date),
    bound = case_when(
      Bound %in% c("N", "North") ~ "North",
      Bound %in% c("S", "South") ~ "South",
      Bound %in% c("E", "East") ~ "East",
      Bound %in% c("W", "West") ~ "West",
      TRUE ~ NA_character_  # Keep only valid directions or set as NA
    ),
    min_delay = `Min Delay`,
    min_gap = `Min Gap`,
    location = case_when(
      str_detect(Location, "DUNDAS") ~ "DUNDAS",
      str_detect(Location, "YORKDALE") ~ "YORKDALE",
      TRUE ~ "OTHER"
    ),
    line = case_when(
      Line %in% c(510, 501) ~ as.character(Line),
      TRUE ~ "OTHER"
    )
  ) %>%
  select(mode, date, day_of_week, bound, min_delay, min_gap, location, line)



#### Combine All Modes ####

# Combine cleaned datasets
combined_data <- bind_rows(cleaned_bus, cleaned_subway, cleaned_streetcar)



#### Save Combined Data ####

# Save as a Parquet file
write_parquet(combined_data, file.path(processed_data_dir, "combined_ttc_delay_data.parquet"))
message("Combined dataset saved as Parquet.")
