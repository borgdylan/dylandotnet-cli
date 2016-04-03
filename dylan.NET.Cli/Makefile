PATH := $(shell pwd)/build:$(PATH)
prefix:= /usr/local

all:
	-dotnet restore --disable-parallel
	-dotnet -v publish --output build

install:
	mkdir -p $(prefix)/lib/dylandotnet-cli
	cp build/*.dll $(prefix)/lib/dylandotnet-cli
	cp build/*.exe $(prefix)/lib/dylandotnet-cli
	cp build/dotnet-compile-dnc $(prefix)/lib/dylandotnet-cli
	cp build/dnc $(prefix)/lib/dylandotnet-cli
	ln -sf $(prefix)/lib/dylandotnet-cli/dotnet-compile-dnc $(prefix)/bin/dotnet-compile-dnc
	ln -sf $(prefix)/lib/dylandotnet-cli/dnc $(prefix)/bin/dnc

uninstall:
	rm $(prefix)/bin/dotnet-compile-dnc
	rm $(prefix)/bin/dnc
	rm -r $(prefix)/lib/dylandotnet-cli

.PHONY: all install uninstall
