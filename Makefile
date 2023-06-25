LDFLAGS="-L/opt/homebrew/opt/lapack/lib"
CPPFLAGS="-I/opt/homebrew/opt/lapack/include"

HOME=/Users/${USER}
ZSH=$(HOME)/.oh-my-zsh
ARCH=$(shell uname -p)

ifeq ($(ARCH),arm)
	BREW_HOME=/opt/homebrew
else
	BREW_HOME=/usr/local/Homebrew
endif

BREW=$(BREW_HOME)/bin/brew

ANSIBLE=$(BREW_HOME)/opt/ansible
XCODE=/Library/Developer/CommandLineTools

APPLICATIONS = \
							 /Applications/Menuwhere.app \
							 /Applications/Dash.app


.PHONY: all install run

all: install

$(ZSH):
	$(info "Installing oh-my-zsh")
	@sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

$(BREW):
	$(info "Installing homebrew..")
	@/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@eval "$$(/opt/homebrew/bin/brew shellenv)"

$(XCODE):
	$(info "Installing XCODE..")
	xcode-select --install

$(ANSIBLE):
	$(info "Installing ansible..")
	brew install ansible

$(APPLICATIONS):
	$(warn "You must manually download $(@F)")

install: $(ZSH) $(BREW) $(XCODE) $(ANSIBLE) $(APPLICATIONS)
	sudo chown -R $(shell whoami) $(BREW_HOME)
	ansible-galaxy install -r requirements.yml

run: install
	ANSIBLE_SSH_PIPELINING=0 ansible-playbook -K -i inventory main.yml

check: install
	ANSIBLE_SSH_PIPELINING=0 ansible-playbook -K -i inventory main.yml --check
