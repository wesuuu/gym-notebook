FROM nvidia/cuda:10.2-cudnn7-runtime-ubuntu18.04
# FROM ubuntu:18.04

RUN apt-get update --fix-missing && \ 
    apt-get install tzdata -y


ENV TZ=Americas/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y --no-install-recommends \
        apt-utils \
        build-essential \
        software-properties-common \
        g++  \
        gcc \
        git  \
        curl  \
        cmake \
        # python3  \
        # python3-pip  \
        cython3  \
        unzip \
        libglu1-mesa-dev \
        libgl1-mesa-dev \
        libosmesa6-dev \
        xvfb \
        patchelf \
        ffmpeg \
        zlib1g-dev \
        libjpeg-dev \
        libopenblas-base  \
        cython3  \
        python3-dev \
        swig \
        xorg-dev \
        sed \
        dpkg \
        xvfb \
        xserver-xephyr \
        wget \
        gnupg \
        pbuilder \
        ubuntu-dev-tools \
        apt-file \
        git \
        linux-headers-$(uname -r) \
        keyboard-configuration \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

COPY ./mnt /mnt

# miniconda
RUN bash /mnt/miniconda.sh -b -p opt/conda && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

ENV PATH=${PATH}:/opt/conda/bin

# tini
RUN TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

# create the conda base env
RUN /opt/conda/bin/conda env update --file /mnt/base.yml

RUN useradd -u 1000 -m wesley
USER wesley
WORKDIR /home/wesley

RUN conda init bash

RUN pip install git+https://github.com/Shmuma/ptan.git

ENV DISPLAY=localhost:0.0
