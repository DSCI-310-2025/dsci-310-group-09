library(testthat)
library(ggplot2)

source("R/generate_confusion_matrix_heatmap.R")


# Create a test data frame
test_df <- data.frame(
    Prediction = c("A", "A", "B", "B"),
    Reference = c("A", "B", "A", "B"),
    Freq = c(20, 5, 3, 25)
    )


# Expected ggplot
expect_heatmap <- ggplot(test_df, aes(x = Prediction, y = Reference, fill = Freq)) +
    geom_tile() +
    geom_text(aes(label = Freq), color = "black", size = 5) +
    scale_fill_gradient(low = "white", high = "lightblue") +
    labs(title = "Test Confusion Matrix Heatmap", x = "Predicted Class", y = "Actual Class") +
    theme_minimal()


# Generate plot
test_that("generate_confusion_matrix_heatmap returns correct heatmap", {
    test_plot <- generate_confusion_matrix_heatmap(test_df,title = "Test Confusion Matrix Heatmap")
    # test if return is ggplot object
    expect_s3_class(test_plot, "ggplot")
    # test if the heatmap is correct
    expect_equal(test_plot$labels$x, "Predicted Class")
    expect_equal(test_plot$labels$y, "Actual Class")
    expect_equal(test_plot$labels$title, "Test Confusion Matrix Heatmap")
    expect_equal(length(test_plot$layers), 2)
})


# Test df is not a data frame
test_that("test if dataset is not a data frame", {
  invalid_input <- "not_a_dataframe"
  expect_error(generate_confusion_matrix_heatmap(invalid_input, title = "Test Confusion Matrix Heatmap"),"conf_df must be a data frame!")
})


# Test missing colums
test_that("generate_confusion_matrix_heatmap throws error if required columns are missing", {
  missing_df <- data.frame(Pred = c("A", "B"), Ref = c("A", "B"))
  expect_error(generate_confusion_matrix_heatmap(missing_df, title = "Test Confusion Matrix Heatmap"),"Missing required columns")
})