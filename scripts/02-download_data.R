#### Preamble ####
# Purpose: Downloads and saves TTC delay data from Open Data Toronto
# Author: Jerry Xia
# Date: December 3, 2024
# Contact: jerry.xia@mail.utoronto.ca
# License: MIT
# Pre-requisites: Install `opendatatoronto` and `tidyverse` packages:
#   install.packages("opendatatoronto")
#   install.packages("tidyverse")



#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)
library(here)

# Define the raw data directory
raw_data_dir <- here("data", "01-raw_data")



#### Download data ####

# Function to fetch and save data
fetch_and_save_data <- function(package_id, resource_name, file_name) {
  resource <- list_package_resources(package_id) |>
    filter(name == resource_name) |>
    get_resource()
  
  write_csv(resource, file.path(raw_data_dir, file_name))
  message(glue::glue("Saved {file_name} successfully."))
}

# Fetch and save subway data
fetch_and_save_data(
  package_id = "996cfe8d-fb35-40ce-b569-698d51fc683b",
  resource_name = "ttc-subway-delay-data-2024",
  file_name = "raw_data_subway.csv"
)

# Fetch and save streetcar data
fetch_and_save_data(
  package_id = "b68cb71b-44a7-4394-97e2-5d2f41462a5d",
  resource_name = "ttc-streetcar-delay-data-2024",
  file_name = "raw_data_streetcar.csv"
)

# Fetch and save bus data
fetch_and_save_data(
  package_id = "e271cdae-8788-4980-96ce-6a5c95bc6618",
  resource_name = "ttc-bus-delay-data-2024",
  file_name = "raw_data_bus.csv"
)
