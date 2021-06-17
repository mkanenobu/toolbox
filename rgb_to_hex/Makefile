.PHONY: default install_deps build install clean

default: build

install_deps:
	dune install

build:
	dune build rgb_to_hex.exe

install:
	cp ./_build/default/rgb_to_hex.exe ../rgb-to-hex

clean:
	dune clean
