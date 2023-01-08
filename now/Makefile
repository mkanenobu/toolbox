NAME := now
BIN_DIR := ~/.local/bin

.PHONY: build
build:
	cargo build --release

.PHONY: clean
clean:
	cargo clean

.PHONY: install
install:
	cp target/release/$(NAME) $(BIN_DIR)