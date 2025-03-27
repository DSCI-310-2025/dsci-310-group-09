library(docopt)
library(utils)
library(readr)
library(knitr)
library(dplyr)
library(ggplot2)
library(ggcorrplot)
source("R/generate_barplot.R")


"This script reads processed data and create visualizations
Usage: 03-visualizations.R --data_path=<data_path> --encode_path=<encode_path> --matrix_path=<model_path> --output_path=<output_path>
" -> doc

# data_path should be data/cleaned/cleaned.RDS
# encode_path should be output/encoded.RDS
# and output_path should be output/

# enter this in terminal or Makefile:
# Rscript code/03-visualizations.R --data_path=data/cleaned/cleaned.RDS --encode_path=output/encoded.RDS --matrix_path=output/matrix.RDS --output_path=output/

opt <- docopt(doc)

# visualization with cleaned data:
data <- read_rds(opt$data_path)
# saves frequency distribution of the target variable
write_rds(table(data$class), paste0(opt$output_path, "tbl_target_dist.RDS"))

# Visualizing the distribution of class
# ggplot(data, aes(x = class, fill = class)) +
#   geom_bar() +
#   theme_minimal() +
#   labs(title = "Figure 1: Distribution of Car Evaluations", x = "Class", y = "Count")
# ggsave(paste0(opt$output_path, "fig_target_dist.png"))

generate_barplot(data, "class", "Class")
ggsave(paste0(opt$output_path, "fig_target_dist.png"))


# Visualizing relationships
features <- c("safety", "buying", "persons", "maint", "lug_boot", "doors")
plot_list <- lapply(features, function(feature) {
  ggplot(data, aes(x = .data[[feature]], fill = class)) +
    geom_bar(position = "dodge") +
    theme_minimal() +
    labs(title = paste("Figure 2 - 7:", feature, "vs. Evaluation Class"))
  ggsave(paste0(opt$output_path, "fig_relation_", feature, "_1.png"))
})

# Visualizing relationships again??
features <- c("safety", "buying", "persons", "maint", "lug_boot", "doors")
plot_list <- lapply(features, function(feature) {
  ggplot(data, aes(x = .data[[feature]], fill = class)) +
    geom_bar(position = "dodge") +
    theme_minimal() +
    labs(title = paste("Figure 9 - 14:", feature, "vs. Evaluation Class"))
  ggsave(paste0(opt$output_path, "fig_relation_", feature, "_2.png"))
})


# visualizations with encoded.RDS
df_balanced <- read_rds(opt$encode_path)
# Visualizing the distribution of class after SMOTE
# ggplot(df_balanced, aes(x = class, fill = class)) +
#   geom_bar() +
#   theme_minimal() +
#   labs(title = "Figure 8: Distribution of Car Evaluations After Feature Engineering", x = "Class", y = "Count")
# ggsave(paste0(opt$output_path, "fig_smote_dist.png"))

generate_barplot(df_balanced, "class", "Class")
ggsave(paste0(opt$output_path, "fig_smote_dist.png"))

# Correlation Heatmap
corr_matrix <- cor(df_balanced |> mutate(across(where(is.factor), as.numeric)))
p <- ggcorrplot(corr_matrix, type = "lower", lab = TRUE)
p <- p + ggtitle("Figure 15: Correlation Heatmap")
ggsave(paste0(opt$output_path, "fig_corr_heatmap.png"), plot = p)


# visualization with model

conf_matrix <- read_rds(opt$matrix_path)
# Convert confusion matrix to data frame
conf_df <- data.frame(conf_matrix$table)
# Plot Confusion Matrix as Heatmap
ggplot(conf_df, aes(x = Prediction, y = Reference, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), color = "black", size = 5) +
  scale_fill_gradient(low = "white", high = "lightblue") +
  labs(title = "Figure 16: Confusion Matrix Heatmap", x = "Predicted Class", y = "Actual Class") +
  theme_minimal()
ggsave(paste0(opt$output_path, "fig_conf_matrix.png"))
