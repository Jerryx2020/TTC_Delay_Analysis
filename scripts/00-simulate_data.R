#### Preamble ####
# Purpose: Simulate TTC delay data focusing on DUNDAS (downtown), YORKDALE (slightly outside downtown),
#          and selected streetcar lines (510 Spadina, 501 Queen).
# Author: Jerry Xia
# Date: 3 December 2024
# Contact: Jerry.xia@mail.utoronto.ca
# License: MIT
# Pre-requisites: Install tidyverse package before running:
#                 install.packages("tidyverse")



#### Workspace setup ####
library(tidyverse)
set.seed(304)



#### Simulate data ####
# Number of rows for simulated data
n <- 1000

# Simulating data for buses, streetcars, and subways
simulated_data <- tibble(
  mode = sample(c("Bus", "Streetcar", "Subway"), n, replace = TRUE, prob = c(0.5, 0.3, 0.2)),
  date = as.Date("2024-01-01") + sample(0:300, n, replace = TRUE), # Standardized format YYYY-MM-DD
  day_of_week = weekdays(date),
  bound = sample(c("North", "South", "East", "West"), n, replace = TRUE),
  min_delay = case_when(
    mode == "Bus" ~ round(rexp(n, rate = 1/12), 0),      # Average 12 mins delay for buses
    mode == "Streetcar" ~ round(rexp(n, rate = 1/15), 0), # Average 15 mins delay for streetcars
    mode == "Subway" ~ round(rexp(n, rate = 1/10), 0)    # Average 10 mins delay for subways
  ),
  min_gap = case_when(
    mode == "Bus" ~ round(runif(n, 5, 30), 0),           # Gaps between buses: 5-30 minutes
    mode == "Streetcar" ~ round(runif(n, 10, 45), 0),    # Gaps between streetcars: 10-45 minutes
    mode == "Subway" ~ round(runif(n, 2, 20), 0)         # Gaps between subways: 2-20 minutes
  ),
  location = sample(
    c("DUNDAS", "YORKDALE", "OTHER"), n, replace = TRUE, prob = c(0.4, 0.3, 0.3) # Adjust probabilities if needed
  ),
  line = ifelse(
    mode == "Streetcar",
    sample(c("510", "501", "OTHER"), n, replace = TRUE, prob = c(0.5, 0.3, 0.2)), # Focus on Spadina and Queen
    NA_character_ # Buses and Subways do not have lines in this context
  )
)

# Remove `line` for buses and subways
simulated_data <- simulated_data %>%
  mutate(line = ifelse(mode != "Streetcar", NA, line))



#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_ttc_delay_data_focus.csv")
