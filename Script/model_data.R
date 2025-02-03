# Load necessary library
library(dplyr)

# Read the dataset
data <- read.csv("~/Family_Size/Data/portugal.csv", stringsAsFactors = FALSE)

# Drop 'X' if it exists
if ("X" %in% names(data)) {
  data$X <- NULL
}

# Convert literacy to binary (1 = Yes, 0 = No)
data$literacy <- ifelse(data$literacy == "yes", 1, 0)

# Ensure 'ageMarried' exists before creating dummy variables
if ("ageMarried" %in% names(data)) {
  data <- data %>%
    mutate(
      ageMarried_15_18 = ifelse(ageMarried == "15to18", 1, 0),
      ageMarried_18_20 = ifelse(ageMarried == "18to20", 1, 0),
      ageMarried_20_22 = ifelse(ageMarried == "20to22", 1, 0),
      ageMarried_22_25 = ifelse(ageMarried == "22to25", 1, 0),
      ageMarried_25_30 = ifelse(ageMarried == "25to30", 1, 0),
      ageMarried_30_plus = ifelse(ageMarried == "30toInf", 1, 0)
    )
  
  # Remove the original 'ageMarried' column
  data$ageMarried <- NULL
}

# Ensure 'region' exists before creating dummy variables
if ("region" %in% names(data)) {
  data <- data %>%
    mutate(
      region_10_20k = ifelse(region == "10-20k", 1, 0),
      region_20k_plus = ifelse(region == "20k+", 1, 0),
      region_lisbon = ifelse(region == "lisbon", 1, 0),
      region_lt10k = ifelse(region == "lt10k", 1, 0),
      region_porto = ifelse(region == "porto", 1, 0)
    )
  
  # Remove the original 'region' column
  data$region <- NULL
}

# Ensure 'children' and 'monthsSinceM' have valid values
data <- data %>%
  filter(!is.na(children), !is.infinite(children), children >= 0) %>%
  filter(!is.na(monthsSinceM), !is.infinite(monthsSinceM), monthsSinceM > 0)

# Save the cleaned dataset
write.csv(data, "~/Family_Size/Data/model.csv", row.names = FALSE)