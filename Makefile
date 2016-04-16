DOTPATH  := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
DOTFILES := $(wildcard _??*)

all: setup

setup:
	@echo 'Create dotfiles'
	@$(foreach file, $(DOTFILES), ln -sfnv $(abspath $(file)) $(HOME)/$(subst _,.,$(file));)
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/provisioner/setup.sh
