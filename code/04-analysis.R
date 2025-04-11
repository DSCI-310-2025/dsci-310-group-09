library(docopt)
library(readr)
library(predictcarcategory)
"This script reads cleaned.RDS object and applies random forest.

Usage: 04-analysis.R --file_path=<file_path> --output_path=<output_path>
" -> doc
# file_path should be data/cleaned/cleaned.RDS
# and output_path should be output/model.RDS

# enter this in terminal or Makefile:
# Rscript code/04-analysis.R  --file_path=output/encoded.RDS --output_path=output/matrix.RDS 

opt <- docopt(doc)

# Read the RDS file
df_balanced <- read_rds(opt$file_path)
conf_matrix <- apply_random_forest(df_balanced)
write_rds(conf_matrix, opt$output_path)
