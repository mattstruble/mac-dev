.PHONY: all install

all: install

install:
	xcode-select --install
	pip3 install ansible
	ansible-galaxy install -r requirements.yml
