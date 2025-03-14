library(docopt)
library(utils)
library(readr)


# Frequency distribution of the target variable
table(data$class)

# Visualizing the distribution of class
ggplot(data, aes(x = class, fill = class)) +
  geom_bar() +
  theme_minimal() +
  labs(title = "Figure 1: Distribution of Car Evaluations", x = "Class", y = "Count")



# Visualizing relationships
features <- c("safety", "buying", "persons", "maint", "lug_boot", "doors")
plot_list <- lapply(features, function(feature) {
  ggplot(data, aes(x = .data[[feature]], fill = class)) +
    geom_bar(position = "dodge") +
    theme_minimal() +
    labs(title = paste("Figure 2 - 7:", feature, "vs. Evaluation Class"))
})

# Display plots separately
for (plot in plot_list) {
  print(plot)
}

# Create a recipe for SMOTE
smote_recipe <- recipe(class ~ ., data = df_encoded) %>%
  step_smote(class, over_ratio = 1) %>%
  prep() %>%
  bake(new_data = NULL)

df_balanced <- smote_recipe

# Visualizing the distribution of class after SMOTE 
ggplot(df_balanced, aes(x = class, fill = class)) +
  geom_bar() +
  theme_minimal() +
  labs(title = "Figure 8: Distribution of Car Evaluations After Feature Engineering", x = "Class", y = "Count")

# Visualizing relationships
features <- c("safety", "buying", "persons", "maint", "lug_boot", "doors")
plot_list <- lapply(features, function(feature) {
  ggplot(data, aes(x = .data[[feature]], fill = class)) +
    geom_bar(position = "dodge") +
    theme_minimal() +
    labs(title = paste("Figure 9 - 14:",feature, "vs. Evaluation Class"))
})

# Display plots separately
for (plot in plot_list) {
  print(plot)
}

# Correlation Heatmap
corr_matrix <- cor(df_balanced %>% mutate(across(where(is.factor), as.numeric)))
corrplot(corr_matrix, method = "color", type = "lower", tl.cex = 0.8)
title("Figure 15: Correlation Heatmap")


conf_matrix <- confusionMatrix(predictions, test$class)
conf_matrix

# Convert confusion matrix to data frame
conf_df <- data.frame(conf_matrix$table)

# Plot Confusion Matrix as Heatmap
ggplot(conf_df, aes(x = Prediction, y = Reference, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), color = "black", size = 5) +
  scale_fill_gradient(low = "white", high = "lightblue") +
  labs(title = "Figure 16: Confusion Matrix Heatmap", x = "Predicted Class", y = "Actual Class") +
  theme_minimal()