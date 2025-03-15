library(randomForest)  
library(docopt)
library(readr)
library(tibble)
library(caret) 


"This script reads cleaned.RDS object and applies random forest.

Usage: 04-analysis.R --file_path=<file_path> --output_path=<output_path>
" -> doc
# file_path should be data/cleaned/cleaned.RDS
# and output_path should be output/model.RDS

# enter this in terminal or Makefile:
# Rscript code/04-analysis.R  --file_path=output/encoded.RDS --output_path=output/matrix.RDS 

opt <- docopt(doc)

df_balanced <- read_rds(opt$file_path)


#Applying Random Forest after encoding and balancing the dataset
n <- nrow(df_balanced)
trainidx <- sample.int(n, floor(n * .75))
testidx <- setdiff(1:n, trainidx)
train <- df_balanced[trainidx, ]
test <- df_balanced[testidx, ]
rf <- randomForest(class ~ ., data = train)
bag <- randomForest(class ~ ., data = train, mtry = ncol(train) - 1)
preds <-  tibble(truth = test$class, rf = predict(rf, test), bag = predict(bag, test))

predictions <- predict(rf, test)
conf_matrix <- confusionMatrix(predictions, test$class)
write_rds(conf_matrix, opt$output_path)
