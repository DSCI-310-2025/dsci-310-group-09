# Car Acceptability Category Prediction

## Contributors
- Jiaming Chang
- Yicheng Huang
- Effie Wang
- Brianna Zhou

## Project Summary
The acceptability of the car is an important factor for the automotive industry. Predicting the acceptability of cars not only supports the consumer's purchasing choice, but also contributes to the car dealer's decision.
Our project aims to build the classification model using the random forest algorithm to predict car acceptability.
This model predicts whether the car is unacceptable, acceptable, good, or very good, based on different features (e.g., buying price, maintenance cost, safety, etc.).
Our project analysis involves exploratory data analysis, classification model building, and data visualization, all completed using R.
Our Random Forest model achieved an impressive overall accuracy of 94.68% and a strong Kappa statistic of 0.8822 on unseen data.

The data set is sourced from the UCI Machine Learning Repository and can be found [here](https://archive.ics.uci.edu/dataset/19/car+evaluation).
The data set contains 1,728 instances and six features.

## How To Run Data Analysis

We use a Docker container image to create a reproducible development environment for this project. 
The steps to create the container on local machine and explore our project is shown below:
1. locate to the local folder you want to clone this project, use 
```
git clone https://github.com/DSCI-310-2025/dsci-310-group-09.git
``` 
to clone down our project repository.

## Dependencies
- R and R packages:
    - tidyverse
    - randomForest
    - caret

## license
This Car Acceptability Category Prediction is licensed under MIT License.
