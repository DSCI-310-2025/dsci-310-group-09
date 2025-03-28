library(ggplot2)

# Function to create a heatmap for confusion matrix
generate_confusion_matrix_heatmap <- function(conf_df, title = "Confusion Matrix Heatmap") {
  # Check if dataset is a data frame
  if (!is.data.frame(conf_df)) {
    stop("conf_df must be a data frame!")
  }
  
  # Check if there are missing values
  if (any(is.na(conf_df))) {
    stop("conf_df not allow missing values!")
  }

  # Check if conf_df contains all columns
  cols <- c("Prediction", "Reference", "Freq")
  missing_cols <- setdiff(cols, names(conf_df))
  if (length(missing_cols) > 0) {
    stop("Missing required columns: ", paste(missing_cols, collapse = ", "))
  }
  
  conf_matrix_heatmap <- ggplot(conf_df, aes(x = Prediction, y = Reference, fill = Freq)) +
    geom_tile() +
    geom_text(aes(label = Freq), color = "black", size = 5) +
    scale_fill_gradient(low = "white", high = "lightblue") +
    labs(title = title, x = "Predicted Class", y = "Actual Class") +
    theme_minimal()
  
  return(conf_matrix_heatmap)
}