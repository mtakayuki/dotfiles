DOTPATH  := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
DOTFILES := $(wildcard _??*)
CONFIGFILES := $(wildcard config/*)

XDG_DIRS := ~/.config ~/.cache
MKDIR := mkdir -p

all: setup

setup: $(CACHE_DIR)
	@echo 'Create dotfiles'
	@$(foreach file, $(DOTFILES), ln -sfnv $(abspath $(file)) $(HOME)/$(file:_%=.%);)
	@$(foreach dir, $(CONFIGFILES), ln -sfnv $(abspath $(dir)) $(HOME)/.$(dir);)
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/provisioner/setup.sh

$(XDG_DIRS):
	$(MKDIR) $@
