library(randomForest)
library(docopt)
library(readr)
library(tibble)
library(caret)

#' Function that applies RandomForest algorithm to the dataset, returns the confusion matrix
#' 
#' @param df a dataframe
#' 
#' @return a confusin matrix based on the RandomForest model
#' @export
#'
#' @examples
#' #example 
#' df_balanced <- tibble(
#'    class = factor(sample(c("A", "B"), 100, replace = TRUE)),
#'    var1 = rnorm(100),
#'    var2 = runif(100)
#'  )
#' conf_mat <- apply_random_forest(data_balanced)
#'
#' \dontrun{
#' apply_random_forest(2048)
#' }

# Define the function
apply_random_forest <- function(df) {
  #set seed for reproducibility
  set.seed(310)

  if (!is.data.frame(df)) {
    stop("Input data must be a dataframe or tibble.")
  }
  
  # Split data into training and testing sets
  n <- nrow(df)
  trainidx <- sample.int(n, floor(n * 0.75))
  testidx <- setdiff(1:n, trainidx)
  train <- df[trainidx, ]
  test <- df[testidx, ]
  
  # Apply Random Forest and Bagging
  rf <- randomForest(class ~ ., data = train)
  bag <- randomForest(class ~ ., data = train, mtry = ncol(train) - 1)
  
  # Generate predictions
  preds <- tibble(truth = test$class, rf = predict(rf, test), bag = predict(bag, test))
  
  # Create confusion matrix
  predictions <- predict(rf, test)
  conf_matrix <- confusionMatrix(predictions, test$class)
  
  #return a confusion matrix
  return(conf_matrix)
}
