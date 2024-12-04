#### Preamble ####
# Purpose: Clean the raw TTC delay data to prepare for analysis
# Author: Jerry Xia
# Date: December 3, 2024
# Contact: jerry.xia@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Raw data files must be present in `data/01-raw_data` directory.
# - Run `02-download_data.R` first to ensure the data exists.



#### Workspace setup ####
library(tidyverse)
library(here)

# Define raw and processed data directories
raw_data_dir <- here("data", "01-raw_data")
processed_data_dir <- here("data", "02-analysis_data")

# Create processed data directory if it doesn't exist
if (!dir.exists(processed_data_dir)) {
  dir.create(processed_data_dir, recursive = TRUE)
}



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
    bound = Direction, # Retain `Direction` as `bound`
    min_delay = `Min Delay`,
    min_gap = `Min Gap`,
    location = case_when(
      str_detect(Location, "DUNDAS") ~ "DUNDAS",
      str_detect(Location, "YORKDALE") ~ "YORKDALE",
      TRUE ~ "OTHER"
    )
  ) %>%
  select(mode, date, day_of_week, bound, min_delay, min_gap, location)



#### Clean Subway Data ####

cleaned_subway <- subway_data %>%
  mutate(
    mode = "Subway",
    date = as.Date(Date, format = "%Y/%m/%d"), # Standardize date format
    day_of_week = weekdays(date),
    bound = Bound,
    min_delay = `Min Delay`,
    min_gap = `Min Gap`,
    location = case_when(
      str_detect(Station, "DUNDAS") ~ "DUNDAS",
      str_detect(Station, "YORKDALE") ~ "YORKDALE",
      TRUE ~ "OTHER"
    )
  ) %>%
  select(mode, date, day_of_week, bound, min_delay, min_gap, location)



#### Clean Streetcar Data ####

cleaned_streetcar <- streetcar_data %>%
  mutate(
    mode = "Streetcar",
    date = as.Date(Date, format = "%d-%m-%Y"), # Standardize date format
    day_of_week = weekdays(date),
    bound = Bound,
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



#### Save Cleaned Data ####

write_csv(cleaned_bus, file.path(processed_data_dir, "cleaned_bus.csv"))
write_csv(cleaned_subway, file.path(processed_data_dir, "cleaned_subway.csv"))
write_csv(cleaned_streetcar, file.path(processed_data_dir, "cleaned_streetcar.csv"))
