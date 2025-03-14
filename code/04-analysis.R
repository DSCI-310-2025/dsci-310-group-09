#Applying Random Forest after encoding and balancing the dataset
n <- nrow(df_balanced )
trainidx <- sample.int(n, floor(n * .75))
testidx <- setdiff(1:n, trainidx)
train <- df_balanced[trainidx, ]
test <- df_balanced[testidx, ]
rf <- randomForest(class ~ ., data = train)
bag <- randomForest(class ~ ., data = train, mtry = ncol(data) - 1)
preds <-  tibble(truth = test$class, rf = predict(rf, test), bag = predict(bag, test))

predictions <- predict(rf, test)
