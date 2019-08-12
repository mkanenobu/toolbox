.PHONY: default build install clean

default: build

build:
	dune build rgb_to_hex.exe

install:
	cp ./_build/default/rgb_to_hex.exe ../rgb-to-hex

clean:
	dune clean
