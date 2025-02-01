# Load necessary libraries
library(dplyr)

# Read the dataset
data <- read.csv("~/Family_Size/Data/portugal.csv")

# Convert 'literacy' to binary (1 for 'yes', 0 for 'no')
data$literacy <- ifelse(data$literacy == "yes", 1, 0)

# Convert 'ageMarried' into numerical format using midpoints
convert_age_married <- function(x) {
  if (x == "30toInf") {
    return(32.5)  # Approximate midpoint assuming 30 to ~35
  } else if (x == "0to15") {
    return(7.5)  # Midpoint assumption
  } else {
    ranges <- as.numeric(unlist(strsplit(x, "to")))
    return(mean(ranges))
  }
}

data$ageMarried <- sapply(data$ageMarried, convert_age_married)

# Convert 'region' into dummy variables
data <- data %>%
  mutate(region = as.factor(region)) %>%
  model.matrix(~ region - 1, data = .) %>%
  as.data.frame() %>%
  bind_cols(data, .) %>%
  select(-region)

# Remove duplicate rows
data <- data %>% distinct()

# Display summary of cleaned dataset
summary(data)

# Save cleaned dataset
write.csv(data, "~/Family_Size/Data/cleaned_portugal.csv", row.names = FALSE)
