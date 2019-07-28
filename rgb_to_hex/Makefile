.PHONY: default build install uninstall test clean

default: build

build:
	dune build rgb_to_hex.exe

install:
	cp ./_build/default/rgb_to_hex.exe ../rgb-to-hex

uninstall:
	dune uninstall

clean:
	dune clean
