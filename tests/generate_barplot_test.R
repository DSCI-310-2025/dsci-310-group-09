library(testthat)
library(ggplot2)

source("R/generate_barplot.R")

# Create a test dataset with explicit counts
test_data <- data.frame(class = factor(rep(c("A", "B", "C"), times = c(5, 3, 2))))

# Expected ggplot
expcted_plot <- ggplot(test_data, aes(x = class, fill = class)) +
    geom_bar() +
    theme_minimal() +
    labs(
        title = "Distribution of Car Evaluations",
        x = "Class",
        y = "Count"
    )


# Generate plot
test_that("make_barplot function works correctly", {
    plot <- generate_barplot(test_data, "class", "Class")
    # Check if the output is a ggplot object
    expect_s3_class(plot, "gg")
    # Check if axis labels is correct
    expect_equal(plot$labels$x, "Class")
    expect_equal(plot$labels$y, "Count")
    # Check if title is correctly set
    expect_equal(plot$labels$title, "Distribution of Car Evaluations")
    # Extract computed counts from the plot
    plot_data <- ggplot_build(plot)$data[[1]]
    actual_counts <- setNames(plot_data$count, levels(test_data$class)[plot_data$x])
    expected_counts <- table(test_data$class)
    expected_counts <- setNames(as.numeric(expected_counts), names(expected_counts))
    # Compare expected and actual counts
    expect_equal(actual_counts, expected_counts)
})

# Edge case: Dataset with only one unique class value
test_that("Edge case - Dataset with only one unique value in class", {
    test_data_single <- data.frame(class = factor(rep("A", times = 5)))
    plot_single <- generate_barplot(test_data_single, "class", "Class")
    # Check if the output is a ggplot object
    expect_s3_class(plot_single, "ggplot")
    # Check if axis labels are correct
    expect_equal(plot_single$labels$x, "Class")
    expect_equal(plot_single$labels$y, "Count")
    # Check if title is correctly set
    expect_equal(plot_single$labels$title, "Distribution of Car Evaluations")
    # Extract computed counts from the plot
    plot_data <- ggplot_build(plot_single)$data[[1]]
    actual_counts <- setNames(plot_data$count, levels(test_data_single$class)[plot_data$x])
    expected_counts <- table(test_data_single$class)
    expected_counts <- setNames(as.numeric(expected_counts), names(expected_counts))
    # Compare expected and actual counts
    expect_equal(actual_counts, expected_counts)
})

test_that("Edge case: Dataset has no count for the column", {
    test_data_zero <- data.frame(class = factor(c("A", "B")))
    plot_zero <- generate_barplot(test_data_zero, "class", "Class")
    expect_s3_class(plot_zero, "ggplot")
    expect_equal(plot_zero$labels$x, "Class")
    expect_equal(plot_zero$labels$y, "Count")
    expect_equal(plot_zero$labels$title, "Distribution of Car Evaluations")
    plot_data <- ggplot_build(plot_zero)$data[[1]]
    actual_counts <- setNames(plot_data$count, levels(test_data_zero$class)[plot_data$x])
    expected_counts <- table(test_data_zero$class)
    expected_counts <- setNames(as.numeric(expected_counts), names(expected_counts))
    # Compare expected and actual counts
    expect_equal(actual_counts, expected_counts)
})

test_that("Edge case: Large dataset", {
    test_data_large <- data.frame(class = factor(sample(letters, 10000, replace = TRUE)))
    plot_large <- generate_barplot(test_data_large, "class", "Test Class")
    expect_s3_class(plot_large, "ggplot")
})

test_that("Edge case - Dataset with duplicate x-axis values", {
    test_data_duplicate <- data.frame(class = factor(rep(c("A", "A", "B", "B", "C", "C"), times = c(1, 1, 1, 1, 1, 1))))
    plot_duplicates <- generate_barplot(test_data_duplicate, "class", "Class")
    expect_s3_class(plot_duplicates, "ggplot")
    expect_equal(plot_duplicates$labels$x, "Class")
    expect_equal(plot_duplicates$labels$y, "Count")
    expect_equal(plot_duplicates$labels$title, "Distribution of Car Evaluations")
    plot_data <- ggplot_build(plot_duplicates)$data[[1]]
    actual_counts <- setNames(plot_data$count, levels(test_data_duplicate$class)[plot_data$x])
    expected_counts <- table(test_data_duplicate$class)
    expected_counts <- setNames(as.numeric(expected_counts), names(expected_counts))
    # Compare expected and actual counts
    expect_equal(actual_counts, expected_counts)
})

test_that("Invalid dataset: Dataset is not a data frame", {
    expect_error(generate_barplot(list(class = factor(c("A", "B", "C"))), "class", "Class"), "Dataset must be a data frame!")
})

test_that("Invalid dataset: Dataset is NULL", {
    expect_error(generate_barplot(NULL, "class", "Class"))
})

test_that("Invalid column: Column is missing", {
    expect_error(generate_barplot(test_data, NULL, "Class"))
})

test_that("Invalid column: Column is not a factor", {
    test_data <- data.frame(class = c("A", "B", "C")) # Not a factor
    expect_error(generate_barplot(test_data, "class", "Class"))
})

test_that("Invalid column: Column is not in the dataset", {
    test_data <- data.frame(other_column = factor(c("A", "B", "C")))
    expect_error(generate_barplot(test_data, "class", "Class"))
})
