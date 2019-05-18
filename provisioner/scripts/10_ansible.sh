#!/bin/bash

set -eu

script_dir=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
. ${script_dir}/../../os.sh

if is_mac; then
  if $(brew list | grep -q ansible); then
    if $(brew outdated | grep -q ansible); then
      brew upgrade ansible
    fi
  else
    rm -f /usr/local/bin/ansible*
    brew install ansible
  fi
elif is_linux; then
  sudo apt-get update
  sudo apt-get install -y software-properties-common
  sudo apt-add-repository -y --update ppa:ansible/ansible
  sudo apt-get install -y ansible
fi
