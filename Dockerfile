# Specify what environment is needed in this container:
FROM rocker/rstudio:4.4.2

## maybe need to install packages in renv, remotes, and tidyverse?? Will add more packages if needed.


RUN Rscript -e "install.packages('renv', repos =c(CRAN = 'https://cloud.r-project.org'))"
RUN Rscript -e "install.packages('remotes', repos =c(CRAN = 'https://cloud.r-project.org'))"
RUN Rscript -e "remotes::install_version('caret', version = '7.0-1', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('tidyverse', version = '2.0.0', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('corrplot', version = '0.95', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('themis', version = '1.0.3', repos = 'https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('recipes', version = '1.1.1', repos = 'https://cloud.r-project.org')"

