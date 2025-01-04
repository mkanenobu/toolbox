BIN = trim

.PHONY: run
run:
	@cat test_file/test.txt | zig build run

.PHONY: build
build:
	@zig build

.PHONY: test
test:
	@zig test src/main.zig

.PHONY: fmt
fmt:
	@zig fmt **/*.zig

.PHONY: clean
clean:
	@rm -rf .zig-cache zig-out

.PHONY: install
install:
	make build && install zig-out/bin/$(BIN) ~/.local/bin/$(BIN)
