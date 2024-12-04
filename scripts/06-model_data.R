#### Preamble ####
# Purpose: Train the best possible model for TTC delays using Random Forest
# Author: Jerry Xia
# Date: December 3, 2024
# Contact: jerry.xia@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Run 03-clean_data.R to generate the combined Parquet file.
# - Install required packages



#### Workspace setup ####
library(tidyverse)
library(arrow)
library(caret)
library(randomForest)

# Define paths
models_dir <- here::here("models")
if (!dir.exists(models_dir)) {
  dir.create(models_dir, recursive = TRUE)
}

# Load the cleaned dataset
combined_data <- read_parquet(here::here("data", "02-analysis_data", "combined_ttc_delay_data.parquet"))



#### Data Preparation ####

# Remove missing values and focus on key variables
model_data <- combined_data %>%
  filter(!is.na(min_delay), !is.na(bound)) %>% # Remove rows with missing key values
  mutate(
    location = factor(location, levels = c("DUNDAS", "YORKDALE", "OTHER")),
    bound = factor(bound, levels = c("North", "South", "East", "West")),
    mode = factor(mode, levels = c("Bus", "Streetcar", "Subway")),
    day_of_week = factor(day_of_week, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
  )



#### Train-Test Split ####

set.seed(304)
train_index <- createDataPartition(model_data$min_delay, p = 0.8, list = FALSE)
train_data <- model_data[train_index, ]
test_data <- model_data[-train_index, ]



#### Random Forest Model ####

# Train the random forest model
set.seed(304)
rf_model <- randomForest(
  min_delay ~ mode + location + bound + day_of_week + min_gap,
  data = train_data,
  importance = TRUE,
  ntree = 500
)

# Save the random forest model
saveRDS(rf_model, file = file.path(models_dir, "random_forest_model_delay.rds"))



#### Model Evaluation ####

# Predict on test data
test_predictions <- predict(rf_model, newdata = test_data)

# Evaluate performance (R-squared and RMSE)
r_squared <- cor(test_predictions, test_data$min_delay)^2
rmse <- sqrt(mean((test_predictions - test_data$min_delay)^2))

# Print evaluation metrics
cat("Random Forest Model Performance:\n")x
cat("R-squared: ", round(r_squared, 3), "\n")
cat("RMSE: ", round(rmse, 3), "\n")



#### Feature Importance ####

# Plot feature importance
importance <- as.data.frame(importance(rf_model))
colnames(importance) <- c("MeanDecreaseAccuracy", "MeanDecreaseGini")
importance$Feature <- rownames(importance)

ggplot(importance, aes(x = reorder(Feature, MeanDecreaseAccuracy), y = MeanDecreaseAccuracy)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Feature Importance (Random Forest)",
    x = "Feature",
    y = "Mean Decrease in Accuracy"
  ) +
  theme_minimal()
