library(docopt)
library(utils)
library(readr)
"This script reads car data from the internet, clean it, and pre-processes it.

Usage: 02-clean-preprocess.R --file_path=<file_path> --output_path=<output_path>
" -> doc
# file_path should be work/data/car.data
# and output_path should be work/data/cleaned.RDS

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