DOTFILES := $(wildcard _??*)

all: setup

setup:
	@echo 'Create dotfiles symlinks'
	@$(foreach file, $(DOTFILES), ln -sfnv $(abspath $(file)) $(HOME)/$(file:_%=.%);)
