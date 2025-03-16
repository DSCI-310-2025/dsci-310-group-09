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
With the data cleaning, our Random Forest model achieves an impressive overall accuracy about 99% and a strong Kappa statistic about 0.99 on unseen data.

The data set is sourced from the UCI Machine Learning Repository and can be found [here](https://archive.ics.uci.edu/dataset/19/car+evaluation).
The data set contains 1,728 instances and six features.

## How To Run Data Analysis

We use a Docker container image to create a reproducible development environment for this project. 
There are two ways you can explore our project:
### Method 1: Create a local image and run the file
The steps to create the container on local machine and explore our project is shown below:
1. locate to the local folder you want to clone this project, use 
```
git clone https://github.com/DSCI-310-2025/dsci-310-group-09.git
``` 
to clone down our project repository.

-----------------------------------
2. make sure you have Docker application activated, and in your terminal, create the docker image by entering:
```
docker  build -t <container_name> .
```
where the `<container_name>` could be any name you want. 

For Mac users, use:
```
docker  build --platform=linux/amd64 -t <container_name> .
```

-------------------
3. make sure you are at the root directory of this project, run the docker container by entering this in your terminal:
```
docker run --rm -it -e PASSWORD="password" -p 8787:8787 -v /$(pwd):/home/rstudio/work <container_name>
```
The `<container_name>` has to be the same name you made in step 2. 

For Mac users, use:
```
docker run --platform=linux/amd64 --rm -it -e PASSWORD="password" -p 8787:8787 -v /$(pwd):/home/rstudio/work <container_name>
```

---------------------
4. Open a browser, enter "localhost:8787" in the searchbar. In the prompt, enter "rstudio" as Username and "password" as Password.
---------------------------  
5. Now you may access all the files in the repository, and able to play around with the `car_acceptability_category_prediction.qmd` within the container!



### Method 2: Pull the pre-made docker image from DockerHub and run the file:
The steps to save the image building hassle and explore our project is shown below:
1. locate to the local folder you want to clone this project, use 
```
git clone https://github.com/DSCI-310-2025/dsci-310-group-09.git
``` 
to clone down our project repository.

----------------------
2. make sure you have Docker application activated, and in your terminal, pull the docker image by entering:
```
docker pull justintrenchcoat/milestone_1:latest
```
-------------------
3. make sure you are at the root directory of this project, run the docker container by entering this in your terminal:
```
docker run --rm -it -e PASSWORD="password" -p 8787:8787 -v /$(pwd):/home/rstudio/work justintrenchcoat/milestone_1
```

For Mac users, use:
```
docker run --platform=linux/amd64 --rm -it -e PASSWORD="password" -p 8787:8787 -v /$(pwd):/home/rstudio/work justintrenchcoat/milestone_1
```
---------------------
4. Open a browser, enter "localhost:8787" in the searchbar. In the prompt, enter "rstudio" as Username and "password" as Password.
---------------------------  
5. Now you may access all the files in the repository, and able to play around with the `car_acceptability_category_prediction.qmd` within the container!

### Usage of Makefile
#### Running the Entire Workflow
The Makefile automates the workflow, from data acquisition to report generation.
To execute all steps, run:
```
make all
```
which removes all older generated files, runs all scripts, and renders Quarto documents.

To excute all steps without clean, run:
```
make report
```

#### Individual Commands
1. Download and Extract Data:
```
make data/original/car.data
```
2. Preprocess and Encode Data:
```
make output/encoded.RDS
```
3. Perform Data Analysis and Modelling:
```
make output/matrix.RDS
```
4. Generate Visualizations and Statistical Summaries:
```
make output/tbl_target_dist.RDS
```
5. Generate Reports (HTML & PDF):
```
make index.html
make reports/car_acceptability_category_prediction.html
make reports/car_acceptability_category_prediction.pdf
```
To remove all generated files and reset the project, use:
```
make clean
```


## Dependencies
- R and R packages:
    - tidyverse(optional)
    - randomForest
    - caret
    - corrplot
    - themis
    - recipes
    - docopt
    - utils
    - readr
    - dplyr
    - knitr
    - ggplot2
    - ggcorrplot
    - tibble
- Quarto
- Docker
- GNU Make (v4.2.1 or later)

## License
This Car Acceptability Category Prediction is licensed under MIT License and Creative Commons License, allowing unrestricted use of both code and non-code materials.
