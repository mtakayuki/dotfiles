#!/bin/bash

set -eu

ansible='ansible-playbook'
if [ "$(uname -s)" == "Darwin" ]; then
  os='mac'
  ansible='/usr/local/bin/ansible-playbook'
elif [ "$(expr substr $(uname -s) 1 9)" == "CYGWIN_NT" ]; then
  os='cygwin'
else
  os='other'
fi

if [ -d "$(dirname $0)/scripts/$os" ]; then
  for s in "$(dirname $0)"/scripts/$os/*.sh
  do
    bash "$s"
  done

fi

cd "$(dirname $0)"/playbooks
if type ${ansible} > /dev/null 2>&1; then
  /usr/local/bin/ansible-playbook -i hosts site.yml
fi
