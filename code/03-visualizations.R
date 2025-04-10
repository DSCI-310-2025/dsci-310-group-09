library(docopt)
library(utils)
library(readr)
library(knitr)
library(dplyr)
library(ggplot2)
library(ggcorrplot)
source("R/generate_barplot.R")
source("R/generate_confusion_matrix_heatmap.R")
source("R/generate_feature_plots.R")


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
generate_barplot(data, "class", "Class")
ggsave(paste0(opt$output_path, "fig_target_dist.png"))


# Visualizing relationships
features <- c("safety", "buying", "persons", "maint", "lug_boot", "doors")

# Generate the plots for original data using the generate_feature_barplots function
plot_list <- generate_feature_barplots(data, features)

# Save each plot using ggsave outside the function
lapply(seq_along(plot_list), function(i) {
  ggsave(paste0(opt$output_path, "fig_relation_", features[i], "_1.png"), plot = plot_list[[i]])
})

# Visualizations with encoded.RDS
df_balanced <- read_rds(opt$encode_path)

# Generate the plots for balanced data using the generate_feature_barplots function
balanced_plot_list <- generate_feature_barplots(df_balanced, features)

# Save each plot using ggsave outside the function
lapply(seq_along(balanced_plot_list), function(i) {
  ggsave(paste0(opt$output_path, "fig_relation_", features[i], "_2.png"), plot = balanced_plot_list[[i]])
})

# Visualizing the distribution of class after SMOTE
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

# Add labels to heatmap
class_labels <- c("unacc", "acc", "good", "vgood")
conf_df$Prediction <- factor(conf_df$Prediction, levels = c(1, 2, 3, 4), labels = class_labels)
conf_df$Reference  <- factor(conf_df$Reference,  levels = c(1, 2, 3, 4), labels = class_labels)

# Plot Confusion Matrix as Heatmap
conf_matrix_plot <- generate_confusion_matrix_heatmap(conf_df, title = "Confusion Matrix Heatmap")
ggsave(paste0(opt$output_path, "fig_conf_matrix.png"), plot = conf_matrix_plot)
