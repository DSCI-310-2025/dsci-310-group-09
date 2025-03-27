source("R/analysis_model.R")
"This script reads cleaned.RDS object and applies random forest.

Usage: 04-analysis.R --file_path=<file_path> --output_path=<output_path>
" -> doc
# file_path should be data/cleaned/cleaned.RDS
# and output_path should be output/model.RDS

# enter this in terminal or Makefile:
# Rscript code/04-analysis.R  --file_path=output/encoded.RDS --output_path=output/matrix.RDS 

opt <- docopt(doc)
conf_matrix <- apply_random_forest(opt$file_path)
write_rds(conf_matrix, opt$output_path)
