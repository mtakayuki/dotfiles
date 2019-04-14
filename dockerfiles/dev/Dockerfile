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

COPY --chown=mtakayuki:mtakayuki home /home/mtakayuki
USER mtakayuki
WORKDIR /home/mtakayuki
