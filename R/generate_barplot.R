library(ggplot2)

# Function to create a bar plot for the class distribution
generate_barplot <- function(dataset, x, x_name) {
    # Check if dataset is a data frame
    if (is.null(dataset) || !is.data.frame(dataset)) {
        stop("Dataset must be a data frame!")
    }

    # Check if x column exists in the dataset
    if (!(x %in% names(dataset))) {
        stop(paste("The column", x, "does not exist in the dataset."))
    }

    # Check if x is categorical and is a factor
    if (!is.factor(dataset[[x]])) {
        stop(paste("The column", x, "must be a factor column."))
    }

    class_distribution <- ggplot(dataset, aes(x = !!sym(x), fill = !!sym(x))) +
        geom_bar() +
        theme_minimal() +
        labs(
            title = "Distribution of Car Evaluations",
            x = x_name,
            y = "Count"
        )

    return(class_distribution)
}
