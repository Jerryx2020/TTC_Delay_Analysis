#### Preamble ####
# Purpose: Perform exploratory data analysis on the combined TTC delay data
# Author: Jerry Xia
# Date: December 3, 2024
# Contact: jerry.xia@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Run 03-clean_data.R to generate the combined Parquet file.
# - Install tidyverse, arrow, and ggplot2 packages:



#### Workspace setup ####
library(tidyverse)
library(arrow)
library(ggplot2)

# Load the cleaned dataset
combined_data <- read_parquet(here::here("data", "02-analysis_data", "combined_ttc_delay_data.parquet"))



#### Exploratory Analysis ####

# Overview of the dataset
glimpse(combined_data)

# Summary statistics
combined_data %>%
  summarise(
    total_records = n(),
    avg_delay = mean(min_delay, na.rm = TRUE),
    avg_gap = mean(min_gap, na.rm = TRUE),
    missing_delay = sum(is.na(min_delay)),
    missing_gap = sum(is.na(min_gap))
  )



#### Visualizations ####

# 1. Delay distribution by mode
ggplot(combined_data, aes(x = min_delay, fill = mode)) +
  geom_histogram(binwidth = 5, position = "dodge", alpha = 0.7) +
  labs(
    title = "Distribution of Delays by Mode",
    x = "Delay (minutes)",
    y = "Count"
  ) +
  theme_minimal()

# 2. Average delay by location
combined_data %>%
  group_by(location) %>%
  summarise(avg_delay = mean(min_delay, na.rm = TRUE)) %>%
  ggplot(aes(x = location, y = avg_delay, fill = location)) +
  geom_col() +
  labs(
    title = "Average Delay by Location",
    x = "Location",
    y = "Average Delay (minutes)"
  ) +
  theme_minimal()

# 3. Delay by day of the week
combined_data %>%
  group_by(day_of_week) %>%
  summarise(avg_delay = mean(min_delay, na.rm = TRUE)) %>%
  ggplot(aes(x = fct_relevel(day_of_week, c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")), y = avg_delay)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Average Delay by Day of the Week",
    x = "Day of the Week",
    y = "Average Delay (minutes)"
  ) +
  theme_minimal()

# 4. Delay distribution by bound (direction)
ggplot(combined_data, aes(x = min_delay, fill = bound)) +
  geom_histogram(binwidth = 5, alpha = 0.7, position = "stack") +
  labs(
    title = "Distribution of Delays by Direction",
    x = "Delay (minutes)",
    y = "Count"
  ) +
  theme_minimal()

# 5. Mode-specific analysis: Streetcar delays by line
combined_data %>%
  filter(mode == "Streetcar") %>%
  group_by(line) %>%
  summarise(avg_delay = mean(min_delay, na.rm = TRUE)) %>%
  ggplot(aes(x = line, y = avg_delay, fill = line)) +
  geom_col() +
  labs(
    title = "Average Delay by Streetcar Line",
    x = "Streetcar Line",
    y = "Average Delay (minutes)"
  ) +
  theme_minimal()
