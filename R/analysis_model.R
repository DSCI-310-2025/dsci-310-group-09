library(randomForest)
library(docopt)
library(readr)
library(tibble)
library(caret)

#' Function that applies RandomForest algorithm to the dataset, returns the confusion matrix
#' 

# Define the function
apply_random_forest <- function(file_path) {
  # Read the RDS file
  df_balanced <- read_rds(file_path)
  
  # Split data into training and testing sets
  n <- nrow(df_balanced)
  trainidx <- sample.int(n, floor(n * 0.75))
  testidx <- setdiff(1:n, trainidx)
  train <- df_balanced[trainidx, ]
  test <- df_balanced[testidx, ]
  
  # Apply Random Forest and Bagging
  rf <- randomForest(class ~ ., data = train)
  bag <- randomForest(class ~ ., data = train, mtry = ncol(train) - 1)
  
  # Generate predictions
  preds <- tibble(truth = test$class, rf = predict(rf, test), bag = predict(bag, test))
  
  # Create confusion matrix
  predictions <- predict(rf, test)
  conf_matrix <- confusionMatrix(predictions, test$class)
  
  #return s confusion matrix
  return(conf_matrix)
}
