library(docopt)
library(utils)
library(readr)
library(dplyr)
library(pointblank)

"This script reads cleaned data produced from 02-clean-process.R, and run series of data validation analysis on it.

Usage: 05-data-validation.R --file_path=<file_path> --report_path=<report_path>
" -> doc
# file_path should be data/cleaned/not_valid.RDS
# and report_path should be output/

# enter this in terminal or Makefile:
# Rscript code/05-data-validation.R --file_path=data/cleaned/not_valid.RDS --report_path=output/

opt <- docopt(doc)
# data validation process
# check if file is in rds format
df_encoded <- read_rds(opt$file_path)
# create an agent
# 1. checking on if column names are correct
# 2. checking on if any column has empty value
# 3. check if missing-ness is beyond some threshold
# 4. check correct data type
# 5. check if response follows distribution
# 6. check if there is any outlier for the variable safety
# 7. check if maint variable has correct category levels
agent <- df_encoded|>create_agent()|>
  col_exists(columns = vars(buying, maint, doors, persons, lug_boot, safety, class))|>
  col_vals_not_null(columns = vars(buying, maint, doors, persons, lug_boot, safety))|>
  col_vals_not_null(columns = vars(class),  actions = action_levels(stop_at = 0.1))|>
  col_is_numeric(vars(buying, maint, doors, persons, lug_boot, safety))|>
  col_is_factor(vars(class))|>
  col_vals_in_set(columns = vars(class), set = c(1,2,3,4))|>
  col_vals_between(columns = vars(safety), left = 1, right = 3, na_pass = TRUE)|>
  col_vals_in_set(columns = vars(maint), set = c(1,2,3,4))|>
  interrogate()

export_report(agent, filename = "DVC.html", path = opt$report_path)

if (!all_passed(agent)) {
  stop("Data validation failed, please check the report at output/DVC.html.")
}


