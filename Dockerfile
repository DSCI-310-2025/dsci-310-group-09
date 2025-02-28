# Specify what environment is needed in this container:
FROM rocker/rstudio:4.4.2

## maybe need to install packages in renv, remotes, and tidyverse?? Will add more packages if needed.


RUN Rscript -e "install.packages('renv', repos =c(CRAN = 'https://cloud.r-project.org'))"
RUN Rscript -e "install.packages('remotes', repos =c(CRAN = 'https://cloud.r-project.org'))"
RUN Rscript -e "remotes::install_version('dplyr', version = '1.0.10', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('ggplot2', version = '3.5.1', repos = 'https://cloud.r-project.org')"

