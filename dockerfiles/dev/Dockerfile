FROM debian:stable-slim

MAINTAINER mtakayuki <mtakayuki1209@gmail.com>

RUN apt-get update && \
  apt-get install sudo && \
  useradd -G sudo -m -s /bin/bash mtakayuki && \
  echo "Defaults visiblepw" >> /etc/sudoers && \
  echo "mtakayuki ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN apt-get update && \
  apt-get install -y \
    curl \
    git \
    less \
    neovim && \
  echo "deb http://deb.debian.org/debian unstable main" >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y \
    python-neovim \
    python3-neovim \
    python3-distutils \
    universal-ctags && \
  curl -kL https://bootstrap.pypa.io/get-pip.py | python2 && \
  pip2 install pynvim && \
  curl -kL https://bootstrap.pypa.io/get-pip.py | python3 && \
  pip3 install \
    pynvim \
    python-language-server \
    flake8 flake8-import-order \
    autopep8 isort yapf \
    vim-vint

RUN apt-get install -y wget && \
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
  mv kubectl /usr/local/bin && \
  chmod +x /usr/local/bin/kubectl && \
  wget https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz && \
  tar xf helm-v2.13.1-linux-amd64.tar.gz && \
  mv linux-amd64/helm linux-amd64/tiller /usr/local/bin && \
  rm -rf linux-amd64 helm-v2.13.1-linux-amd64.tar.gz

COPY home /root
WORKDIR /root
