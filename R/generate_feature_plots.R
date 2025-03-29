library(ggplot2)

# Function to create bar plots for categorical features against class
generate_feature_barplots <- function(data, features) {
  # Check if data is a data frame
  if (!is.data.frame(data)) {
    stop("data must be a data frame!")
  }
  
  # Check if features is a character vector
  if (!is.character(features)) {
    stop("features must be a character vector!")
  }
  
  # Check if all features exist in the dataset
  missing_features <- setdiff(features, names(data))
  if (length(missing_features) > 0) {
    stop("Missing required columns: ", paste(missing_features, collapse = ", "))
  }
  
  # Check if class column exists
  if (!"class" %in% names(data)) {
    stop("The dataset must contain a 'class' column!")
  }
  
   # Generate bar plots for each feature
  plot_list <- lapply(features, function(feature) {
    ggplot(data, aes(x = .data[[feature]], fill = class)) +
      geom_bar(position = "dodge") +
      theme_minimal() +
      labs(title = paste("Feature Analysis:", feature, "vs. Evaluation Class"),
           x = feature, y = "Count")
  })
  
  return(plot_list)
}
