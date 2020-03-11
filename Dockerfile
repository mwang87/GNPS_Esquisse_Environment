FROM continuumio/miniconda3:latest
MAINTAINER Mingxun Wang "mwang87@gmail.com"

WORKDIR /app
RUN apt-get update -y
RUN conda create -n r_env r-essentials=3.6.0 r-base=3.6.1
RUN /bin/bash -c "source activate r_env"
RUN echo "source activate r_env" > ~/.bashrc
RUN conda install -n r_env -c conda-forge r-esquisse=0.3.0
RUN conda install -n r_env -c conda-forge libiconv
RUN conda install -n r_env -c conda-forge r-extrafont 
RUN apt-get update \
    && wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.7_all.deb -P ~/Downloads \
    && apt install ~/Downloads/ttf-mscorefonts-installer_3.7_all.deb -y \
    && apt-mark hold ttf-mscorefonts-installer

COPY . /app
WORKDIR /app