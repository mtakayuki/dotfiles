#!/bin/bash

set -eu

script_dir="$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)"
. ${script_dir}/../os.sh

for s in "${script_dir}"/scripts/*.sh
do
#  bash "$s"
  echo $s
done 

cd "${script_dir}"/playbooks

if is_mac; then
  /usr/local/bin/ansible-playbook -i hosts site_mac.yml
elif is_linux; then
  /usr/bin/ansible-playbook -i hosts site_linux.yml
fi
