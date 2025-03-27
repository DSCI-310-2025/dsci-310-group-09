library(testthat)
library(ggplot2)

source("generate_barplot.R")

# Create a test dataset with explicit counts
test_data <- data.frame(
    class = factor(rep(c("A", "B", "C"), times = c(5, 3, 2)))
)
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
    plot <- make_barplot(test_data, "class", "Class")
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
test_that("Edge case - Dataset with only one data point", {
    test_data_single <- data.frame(class = factor(rep("A", times = 5)))
    plot_single <- make_barplot(test_data_single, "class", "Class")
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
