FROM debian:testing

MAINTAINER Philipp Ross <philippross@gmail.com>

# Install all OS dependencies for fully functional notebook server
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -yq --no-install-recommends \
    git \
    vim \
    wget \
    build-essential \
    python-dev \
    ca-certificates \
    bzip2 \
    unzip \
    libsm6 \
    supervisor \
    sudo \
    libxrender1 \
    fonts-dejavu \
    gfortran \
    gcc \
		zlib1g-dev \
		libhdf5-dev \
    && apt-get clean

ENV CONDA_DIR /opt/conda
ENV NB_USER phil

# Install conda
RUN echo 'export PATH=$CONDA_DIR/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh && \
    /bin/bash Miniconda-latest-Linux-x86_64.sh -b -p $CONDA_DIR && \
    rm Miniconda-latest-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda install --yes conda==3.16.0

# Create non-root user
RUN useradd -m -s /bin/bash $NB_USER
RUN chown -R $NB_USER:$NB_USER $CONDA_DIR
RUN chown $NB_USER:$NB_USER /home/$NB_USER -R

# Configure user environment
USER $NB_USER
ENV HOME /home/$NB_USER
ENV SHELL /bin/bash
ENV USER $NB_USER
ENV PATH $CONDA_DIR/bin:$PATH

# Setup a work directory rooted in home for ease of volume mounting
ENV WORK $HOME/work
RUN mkdir -p $WORK
WORKDIR $WORK

# Install Jupyter notebook
RUN conda install --yes \
    ipython-notebook==3.2 \
    terminado \
    && conda clean -yt

# Configure Jupyter
RUN ipython profile create

# Configure container startup
USER root

# Add local files as late as possible to avoid cache busting
COPY ipython_notebook_config.py $HOME/.ipython/profile_default/
COPY notebook.conf /etc/supervisor/conf.d/
COPY enable_sudo.sh /usr/local/bin/
RUN chown $NB_USER:$NB_USER $HOME/.ipython/profile_default/ipython_notebook_config.py

# Install additional kernels and packages
COPY install_python2.sh /usr/local/bin/
COPY install_julia.sh /usr/local/bin/

RUN bash /usr/local/bin/install_python2.sh
RUN bash /usr/local/bin/install_julia.sh

EXPOSE 8888
CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
