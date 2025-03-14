library(docopt)
library(utils)
library(readr)
library(dplyr)
library(themis) # For SMOTE
library(recipes) # FOR SMOTE

"This script reads car data from the 'data' folder, cleans it, and processes it.

Usage: 02-clean-process.R --file_path=<file_path> --data_path=<data_path> --encode_path=<encode_path>
" -> doc
# file_path should be data/original/car.data
# and data_path should be data/clean/cleaned.RDS
# encode_path should be output/encoded.RDS

# enter this in terminal or Makefile:
# code/02-clean-process.R --file_path=data/original/car.data --data_path=data/cleaned/cleaned.RDS --encode_path=output/encoded.RDS

opt <- docopt(doc)

data <- read.table(opt$file_path, header = FALSE, sep = ",")
data|>nrow()
data <- data |> rename(buying = V1,
                       maint = V2,
                       doors = V3,
                       persons = V4, 
                       lug_boot = V5,
                       safety = V6,
                       class = V7)
data$buying <- as.factor(data$buying) 
data$maint <- as.factor(data$maint) 
data$doors <- as.factor(data$doors) 
data$persons <- as.factor(data$persons) 
data$lug_boot <- as.factor(data$lug_boot) 
data$safety <- as.factor(data$safety) 
data$class <- as.factor(data$class) 

write_rds(data, opt$data_path)

# Ordinal Encoding of Categorical Variables
ordinal_mapping <- list(
  buying = c("low" = 1, "med" = 2, "high" = 3, "vhigh" = 4),
  maint = c("low" = 1, "med" = 2, "high" = 3, "vhigh" = 4),
  doors = c("2" = 2, "3" = 3, "4" = 4, "5more" = 5),
  persons = c("2" = 2, "4" = 4, "more" = 5),
  lug_boot = c("small" = 1, "med" = 2, "big" = 3),
  safety = c("low" = 1, "med" = 2, "high" = 3),
  class = c("unacc" = 1, "acc" = 2, "good" = 3, "vgood" = 4)
)

df_encoded <- data %>% mutate(across(names(ordinal_mapping), ~ ordinal_mapping[[cur_column()]][.]))

#There is a great imbalance across different classes, introducing SMOTE to generate synthetic samples in order to improve the distribution
df_encoded$class <- as.factor(df_encoded$class)  # Ensure class is a factor

# Create a recipe for SMOTE
smote_recipe <- recipe(class ~ ., data = df_encoded) %>%
  step_smote(class, over_ratio = 1) %>%
  prep() %>%
  bake(new_data = NULL)

df_balanced <- smote_recipe
write_rds(df_balanced, opt$encode_path)