PATH := $(PATH):$(shell pwd)/build
prefix:= /usr/local

all:
	dotnet restore
	dotnet -v publish --output build

install:
	mkdir -p $(prefix)/lib/dylandotnet-cli
	cp build/* $(prefix)/lib/dylandotnet-cli
	ln -s $(prefix)/lib/dylandotnet-cli/dotnet-compile-dnc $(prefix)/bin/dotnet-compile-dnc

uninstall:
	rm $(prefix)/bin/dotnet-compile-dnc
	rm -r $(prefix)/lib/dylandotnet-cli

.PHONY: all install uninstall
