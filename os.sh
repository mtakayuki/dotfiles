#! /bin/bash

function is_linux() {
  [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]
}

function is_mac() {
  [ "$(uname)" == 'Darwin' ]
}
