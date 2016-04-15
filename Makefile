DOTFILES := $(wildcard _??*)

all: setup

setup:
	@echo 'Create dotfiles'
	@$(foreach file, $(DOTFILES), ln -sfnv $(abspath $(file)) $(HOME)/$(subst _,.,$(file));)
