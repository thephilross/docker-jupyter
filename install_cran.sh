#conda config --add channels r
#conda install --yes \
#	r-base \
#	r-irkernel \
#	r-ggplot2 \
#	r-dplyr \
#	r-stringr \
#	r-tidyr \
#	r-rmarkdown \
#	r-foreach \
#	r-randomforest \
#	r-gplots
#conda install --yes -c https://conda.anaconda.org/thephilross \
#	r-cowplot

# Install Base R
apt-get update && apt-get install -y --no-install-recommends \
	ed \
	less \
	locales \
	ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8

## Use Debian unstable via pinning -- new style via APT::Default-Release
echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
    && echo 'APT::Default-Release "testing";' > /etc/apt/apt.conf.d/default

R_BASE_VERSION=3.2.1

## Now install R and littler, and create a link for littler in /usr/local/bin
## Also set a default CRAN repo, and make sure littler knows about it too
apt-get update && apt-get install -t unstable -y --no-install-recommends \
    littler/unstable \
    r-base=${R_BASE_VERSION}* \
    r-base-dev=${R_BASE_VERSION}* \
    r-recommended=${R_BASE_VERSION}* \
        && echo 'options(repos = list(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
        && echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r \
    && ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r \
    && ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r \
    && ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
    && ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
    && install.r docopt \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    && rm -rf /var/lib/apt/lists/*

# Install hadleyverse
echo 'deb http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list \
  && gpg --keyserver keyserver.ubuntu.com --recv-keys AE05705B842492A68F75D64E01BF7284B26DD379 \
  && gpg --export AE05705B842492A68F75D64E01BF7284B26DD379  | apt-key add - \
  && echo 'deb-src http://debian-r.debian.net/debian-r/ unstable main' >> /etc/apt/sources.list \
  && echo 'deb-src http://http.debian.net/debian testing main' >> /etc/apt/sources.list

## LaTeX:
## This installs inconsolata fonts used in R vignettes/manuals manually since texlive-fonts-extra is HUGE

apt-get update && apt-get install -y --no-install-recommends \
    aspell \
    aspell-en \
    ghostscript \
    imagemagick \
    lmodern \
    texlive-fonts-recommended \
    texlive-humanities \
    texlive-latex-extra \
    texinfo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && cd /usr/share/texlive/texmf-dist \
  && wget http://mirrors.ctan.org/install/fonts/inconsolata.tds.zip \
  && unzip inconsolata.tds.zip \
  && rm inconsolata.tds.zip \
  && echo "Map zi4.map" >> /usr/share/texlive/texmf-dist/web2c/updmap.cfg \
  && mktexlsr \
  && updmap-sys

## Install some external dependencies. 360 MB
apt-get update && apt-get install -y --no-install-recommends -t unstable \
    build-essential \
    default-jdk \
    default-jre \
    libcurl4-openssl-dev \
    libcairo2-dev \
    libssl-dev \
    libgsl0-dev \
    libmysqlclient-dev \
    libopenblas-base \
    libpq-dev \
    libsqlite3-dev \
    libv8-dev \
    libxcb1-dev \
    libxdmcp-dev \
    libxml2-dev \
    libxslt1-dev \
    libxt-dev \
    r-cran-hexbin \
    r-cran-mnormt \
    r-cran-rgl \
    r-cran-rsqlite.extfuns \
  && R CMD javareconf \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## Install the R packages. 
install2.r --error \
    broom \
    DiagrammeR \
    devtools \
    dplyr \
    ggplot2 \
    haven \
    httr \
    knitr \
    packrat \
    pryr \
    reshape2 \
    rmarkdown \
    rvest \
    readr \
    readxl \
    testthat \
    tidyr \
    shiny \
    xml2 \
    cowplot \
    DT \
    ggvis \
    foreach \
    gplots \
    NeatMap \
    glmnet
## Manually install (useful packages from) the SUGGESTS list of the above packages.
## (because --deps TRUE can fail when packages are added/removed from CRAN)
install2.r --error \
    base64enc \
    Cairo \
    codetools \
    covr \
    data.table \
    downloader \
    gridExtra \
    gtable \
#    hexbin \
    Hmisc \
    htmlwidgets \
    jpeg \
    Lahman \
    lattice \
    lintr \
    MASS \
    PKI \
    png \
    microbenchmark \
    mgcv \
    mapproj \
    maps \
    maptools \
    mgcv \
    multcomp \
    nlme \
    nycflights13 \
    quantreg \
    Rcpp \
    rJava \
    roxygen2 \
    RMySQL \
    RPostgreSQL \
    RSQLite \
    testit \
    V8 \
    XML \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds
