library(testthat)
library(ggplot2)

source("R/generate_feature_barplots.R")

# Create a test dataset
test_data <- data.frame(
  class = factor(c("A", "B", "A", "B", "A", "B", "A", "B")),
  feature1 = c("X", "X", "Y", "Y", "X", "Z", "Z", "X"),
  feature2 = c("M", "N", "M", "N", "M", "M", "N", "N")
)

# Expected ggplot for feature1
expected_plot_feature1 <- ggplot(test_data, aes(x = feature1, fill = class)) +
  geom_bar(position = "dodge") +
  theme_minimal() +
  labs(
    title = "Feature Analysis: feature1 vs. Evaluation Class",
    x = "feature1",
    y = "Count"
  )

# Expected ggplot for feature2
expected_plot_feature2 <- ggplot(test_data, aes(x = feature2, fill = class)) +
  geom_bar(position = "dodge") +
  theme_minimal() +
  labs(
    title = "Feature Analysis: feature2 vs. Evaluation Class",
    x = "feature2",
    y = "Count"
  )

# Generate plot
test_that("generate_feature_barplots works correctly", {
  plot_list <- generate_feature_barplots(test_data, c("feature1", "feature2"))
  
  # Check if the return value is a list of ggplot objects
  expect_is(plot_list, "list")
  expect_s3_class(plot_list[[1]], "ggplot")
  expect_s3_class(plot_list[[2]], "ggplot")
  
  # Check if the plots are generated correctly
  expect_equal(plot_list[[1]]$labels$title, "Feature Analysis: feature1 vs. Evaluation Class")
  expect_equal(plot_list[[2]]$labels$title, "Feature Analysis: feature2 vs. Evaluation Class")
  
  # Check if axis labels are correctly set
  expect_equal(plot_list[[1]]$labels$x, "feature1")
  expect_equal(plot_list[[1]]$labels$y, "Count")
  expect_equal(plot_list[[2]]$labels$x, "feature2")
  expect_equal(plot_list[[2]]$labels$y, "Count")
})

# Edge case: Invalid dataset type
test_that("Invalid dataset type throws error", {
  expect_error(generate_feature_barplots("invalid_dataset", c("feature1", "feature2")), "data must be a data frame!")
})

# Edge case: Invalid features input (not a character vector)
test_that("Invalid features input throws error", {
  expect_error(generate_feature_barplots(test_data, 123), "features must be a character vector!")
})

# Edge case: Missing feature column
test_that("Missing feature column throws error", {
  expect_error(generate_feature_barplots(test_data, c("missing_feature")), "Missing required columns: missing_feature")
})

# Edge case: Missing class column
test_that("Missing class column throws error", {
  test_data_no_class <- test_data
  test_data_no_class$class <- NULL
  expect_error(generate_feature_barplots(test_data_no_class, c("feature1")), "The dataset must contain a 'class' column!")
})

# Edge case: Empty dataset
test_that("Empty dataset throws error", {
  empty_data <- data.frame(class = factor(), feature1 = character(), feature2 = character())
  expect_error(generate_feature_barplots(empty_data, c("feature1", "feature2")), "Missing required columns: feature1, feature2")
})

# Edge case: Features not present in the dataset
test_that("Features not present in the dataset throws error", {
  expect_error(generate_feature_barplots(test_data, c("nonexistent_feature")), "Missing required columns: nonexistent_feature")
})

# Edge case: Test with a large dataset
test_that("Generate plots for large dataset", {
  large_data <- data.frame(
    class = factor(sample(c("A", "B", "C"), 10000, replace = TRUE)),
    feature1 = sample(letters, 10000, replace = TRUE),
    feature2 = sample(letters, 10000, replace = TRUE)
  )
  plot_list_large <- generate_feature_barplots(large_data, c("feature1", "feature2"))
  expect_is(plot_list_large, "list")
  expect_s3_class(plot_list_large[[1]], "ggplot")
  expect_s3_class(plot_list_large[[2]], "ggplot")
})

# Edge case: Check if function handles NULL features correctly
test_that("Null features throws error", {
  expect_error(generate_feature_barplots(test_data, NULL), "features must be a character vector!")
})
