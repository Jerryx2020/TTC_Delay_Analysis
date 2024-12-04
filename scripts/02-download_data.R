#### Preamble ####
# Purpose: Downloads and saves the data from opendatatoronto
# Author: Jerry Xia
# Date: December 3, 2024
# Contact: jerry.xia@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` and `opendatatoronto` packages must be installed



#### Workspace setup ####
library(opendatatoronto)
library(here)
library(tidyverse)



#### Download data ####

# Get all the bus data
bus_data <- list_package_resources("e271cdae-8788-4980-96ce-6a5c95bc6618") |>
  filter(name == "ttc-bus-delay-data-2024") |>
  get_resource()

# Get all the subway data
subway_data <- list_package_resources("996cfe8d-fb35-40ce-b569-698d51fc683b") |>
  filter(name == "ttc-subway-delay-data-2024") |>
  get_resource()

# Get all the streetcar data
streetcar_data <- list_package_resources("b68cb71b-44a7-4394-97e2-5d2f41462a5d") |>
  filter(name == "ttc-streetcar-delay-data-2024") |>
  get_resource()



#### Save data ####

# Create raw data directory if it doesn't exist
if (!dir.exists(here::here("data", "01-raw_data"))) {
  dir.create(here::here("data", "01-raw_data"), recursive = TRUE)
}

# Save datasets as CSVs
write_csv(bus_data, here::here("data/01-raw_data/raw_data_bus.csv"))
write_csv(subway_data, here::here("data/01-raw_data/raw_data_subway.csv"))
write_csv(streetcar_data, here::here("data/01-raw_data/raw_data_streetcar.csv"))
