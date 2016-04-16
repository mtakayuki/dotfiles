#!/bin/bash

set -eu

for s in "$(dirname $0)"/scripts/*.sh
do
  bash "$s"
done 

cd "$(dirname $0)"/playbooks

ansible-playbook -i hosts site.yml
