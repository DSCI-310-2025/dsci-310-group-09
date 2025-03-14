library(docopt)
"This script downloads car data from internet, and saves it to 'data' folder.

Usage: 01-load.R --url_path=<url_path> --output_path=<output_path>
" -> doc

# enter this in terminal or Makefile:
# code/01-load.R --url_path=https://archive.ics.uci.edu/static/public/19/car+evaluation.zip --output_path=data/original/

opt <- docopt(doc)

# this would pull the dataset from original url, extract the zip file and store everything in data directory
url <- opt$url_path
download.file(url, destfile = paste0(opt$output_path, "car_evaluation.zip"))
unzip(paste0(opt$output_path, "car_evaluation.zip"), exdir = opt$output_path)
