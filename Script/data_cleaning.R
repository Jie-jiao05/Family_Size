# Load necessary libraries
library(dplyr)

# Read the dataset
data <- read.csv("~/Family_Size/Data/portugal.csv")

# Convert 'literacy' to binary (1 for 'yes', 0 for 'no')
data$literacy <- ifelse(data$literacy == "yes", 1, 0)

# Convert 'ageMarried' into categorical dummy variables, using '22to25' as the reference group
data <- data %>%
  mutate(ageMarried = as.factor(ageMarried)) %>%
  mutate(ageMarried = relevel(ageMarried, ref = "22to25"))  # Set '22to25' as reference group

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



