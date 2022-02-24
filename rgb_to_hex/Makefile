.PHONY: default install_deps build install clean

default: build

install_deps:
	dune install

build:
	dune build rgb_to_hex.exe

install:
	install ./_build/default/rgb_to_hex.exe ~/.local/bin/rgb-to-hex

clean:
	dune clean
