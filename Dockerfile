# Specify what environment is needed in this container:
FROM rocker/rstudio:4.4.2

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    zlib1g-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libgit2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libudunits2-dev \
    && apt-get clean

## maybe need to install packages in renv, remotes, and tidyverse?? Will add more packages if needed.
RUN Rscript -e "install.packages(c('renv', 'remotes'), repos = c(CRAN = 'https://cloud.r-project.org'))" && \
    Rscript -e "remotes::install_version('pointblank', version = '0.12.2', repos = 'https://cloud.r-project.org')" &&\
    Rscript -e "remotes::install_version('caret', version = '7.0-1', repos = 'https://cloud.r-project.org')" && \
    Rscript -e "remotes::install_version('tidyverse', version = '2.0.0', repos = 'https://cloud.r-project.org')" && \
    Rscript -e "remotes::install_version('corrplot', version = '0.95', repos = 'https://cloud.r-project.org')" && \
    Rscript -e "remotes::install_version('themis', version = '1.0.3', repos = 'https://cloud.r-project.org')" && \
    Rscript -e "remotes::install_version('recipes', version = '1.1.1', repos = 'https://cloud.r-project.org')" && \
    Rscript -e "remotes::install_version('randomForest', version = '4.7-1.2', repos = 'https://cloud.r-project.org')" &&\
    Rscript -e "remotes::install_version('docopt', version = '0.7.1', repos = 'https://cloud.r-project.org')" &&\
    Rscript -e "remotes::install_version('ggcorrplot', version = '0.1.4.1', repos = 'https://cloud.r-project.org')" &&\
    Rscript -e "remotes::install_version('testthat', version = '3.2.3', repos = 'https://cloud.r-project.org')"

RUN R -e 'devtools::install_github("DSCI-310-2025/predictcarcategory@v0.0.0.9000")'
