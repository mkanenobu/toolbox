.PHONY: run
run:
	@zig build run

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
	zig build -Doptimize=ReleaseFast && install zig-out/bin/wct ~/.local/bin/wct
