FROM ubuntu:16.04

# Install system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
      bzip2 \
      g++ \
      git \
      curl \
      graphviz \
      libgl1-mesa-glx \
      libhdf5-dev \
      openmpi-bin \
      wget && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get upgrade && apt-get update && apt install -y ca-certificates

# Install conda
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

RUN wget --quiet --no-check-certificate https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh && \
    echo "c59b3dd3cad550ac7596e0d599b91e75d88826db132e4146030ef471bb434e9a *Miniconda3-4.2.12-Linux-x86_64.sh" | sha256sum -c - && \
    /bin/bash /Miniconda3-4.2.12-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-4.2.12-Linux-x86_64.sh && \
    echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh

# Install Python packages and keras
ENV NB_USER keras
ENV NB_UID 1000

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    chown $NB_USER $CONDA_DIR -R && \
    mkdir -p /src && \
    chown $NB_USER /src

ARG python_version=3.6

RUN conda config --append channels conda-forge
RUN conda install -y python=${python_version} && \
    pip install --upgrade pip && \
    pip install tensorflow && \
    conda install \
      h5py \
      && \
    git clone git://github.com/keras-team/keras.git /src && pip install -e /src[tests] && \
    pip install git+git://github.com/keras-team/keras.git && \
    conda clean -yt

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV PYTHONPATH='/src/:$PYTHONPATH'

WORKDIR /src

# Gsutil Setting
RUN curl https://sdk.cloud.google.com | bash && \
    ln -s  /root/google-cloud-sdk/bin/gsutil  /usr/local/bin/gsutil && \
    ln -s  /root/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud

# ML Engine

RUN git clone https://github.com/SnowMasaya/keras-cloud-ml-engine && \
    cd /src/keras-cloud-ml-engine && \
    mkdir data

RUN cd /src/keras-cloud-ml-engine && \
    curl -O https://s3.amazonaws.com/img-datasets/mnist.pkl.gz  && \
    gzip -d mnist.pkl.gz  && \
    mv mnist.pkl data/  && \
    mv /src/keras-cloud-ml-engine/data /src/keras-cloud-ml-engine/mnist/data

RUN apt-get install -y vim

WORKDIR /src/keras-cloud-ml-engine

ENV BUCKET_NAME=your-bucket-name
ENV JOB_NAME="mnist_mlp_train_$(date +%Y%m%d_%H%M%S)"
ENV JOB_DIR=gs://$BUCKET_NAME/$JOB_NAME
ENV REGION=asia-east1


