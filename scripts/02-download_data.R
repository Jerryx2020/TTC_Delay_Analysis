#### Preamble ####
# Purpose: Downloads and saves the data from opendatatoronto
# Author: Jerry Xia
# Date: December 3, 2024
# Contact: jerry.xia@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(opendatatoronto)
library(here)
library(tidyverse)

#### Download data ####
# Define a function to safely read and save data
read_and_save <- function(resource_id, dataset_name, raw_data_dir) {
  resource <- list_package_resources(resource_id) |>
    filter(name == dataset_name) |>
    get_resource()
  
  # Convert problematic columns to character (example adjustment)
  resource <- resource |>
    mutate(across(where(is.character), ~ as.character(.))) # Adjust based on inspection
  
  write_csv(resource, file.path(raw_data_dir, paste0("raw_", dataset_name, ".csv")))
}

# Create raw data directory if not exists
if (!dir.exists(here("data", "01-raw_data"))) {
  dir.create(here("data", "01-raw_data"), recursive = TRUE)
}

# Download datasets
read_and_save("e271cdae-8788-4980-96ce-6a5c95bc6618", "ttc-bus-delay-data-2024", here("data", "01-raw_data"))
read_and_save("996cfe8d-fb35-40ce-b569-698d51fc683b", "ttc-subway-delay-data-2024", here("data", "01-raw_data"))
read_and_save("b68cb71b-44a7-4394-97e2-5d2f41462a5d", "ttc-streetcar-delay-data-2024", here("data", "01-raw_data"))