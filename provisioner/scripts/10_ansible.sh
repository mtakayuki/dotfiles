#!/bin/bash

if $(brew list | grep -q ansible); then
  if $(brew outdated | grep -q ansible); then
    brew upgrade ansible
  fi
else
  rm -f /usr/local/bin/ansible*
  brew install ansible
fi
