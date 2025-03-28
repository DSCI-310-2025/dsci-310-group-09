library(testthat)


source("R/analysis_model.R")

test_that("apply_random_forest is reproducible with set seed", {
  # Create sample balanced data set
  set.seed(123)
  df_balanced <- tibble(
    class = factor(sample(c("A", "B"), 100, replace = TRUE)),
    var1 = rnorm(100),
    var2 = runif(100)
  )
  
  # Run the function twice on the same data
  result1 <- apply_random_forest(df_balanced)
  result2 <- apply_random_forest(df_balanced)
  
  # Check that the results are identical with the same seed
  expect_equal(result1, result2)
})

test_that("apply_random_forest handles incorrect data format", {
  # Create a list instead of a dataframe
  df_invalid <- list(a = 1, b = 2)
  
  # Expect an error when passing incorrect format
  expect_error(
    apply_random_forest(df_invalid),
    "Input data must be a dataframe or tibble."
  )
})


test_that("apply_random_forest returns a confusionMatrix object", {
  # Create sample data
  set.seed(123)
  df_balanced <- tibble(
    class = factor(sample(c("A", "B"), 100, replace = TRUE)),
    var1 = rnorm(100),
    var2 = runif(100)
  )
  
  # Run the function
  result <- apply_random_forest(df_balanced)
  
  # Check that the result is of class "confusionMatrix"
  expect_s3_class(result, "confusionMatrix")
})

test_that("apply_random_forest works with small datasets", {
  # Create a small dataset
  df_small <- tibble(
    class = factor(c("A", "B", "A", "B")),
    var1 = c(0.1, 0.2, 0.3, 0.4),
    var2 = c(1.1, 1.2, 1.3, 1.4)
  )
  
  # Run the function
  result <- apply_random_forest(df_small)
  
  # Check if confusion matrix is returned correctly
  expect_s3_class(result, "confusionMatrix")
})

test_that("apply_random_forest works with a single feature dataset", {
  # Create a dataset with one feature
  df_single_feature <- tibble(
    class = factor(sample(c("A", "B"), 50, replace = TRUE)),
    var1 = rnorm(50)
  )
  
  # Run the function
  result <- apply_random_forest(df_single_feature)
  
  # Check if confusion matrix is returned correctly
  expect_s3_class(result, "confusionMatrix")
})

test_that("apply_random_forest works with unbalanced datasets", {
  # Create an unbalanced dataset
  df_unbalanced <- tibble(
    class = factor(c(rep("A", 90), rep("B", 10))),
    var1 = rnorm(100),
    var2 = runif(100)
  )
  
  # Run the function
  result <- apply_random_forest(df_unbalanced)
  
  # Check if confusion matrix is returned correctly
  expect_s3_class(result, "confusionMatrix")
})
