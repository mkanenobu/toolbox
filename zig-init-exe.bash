#!/usr/bin/env bash

zig init-exe

touch .gitignore
cat > .gitignore <<EOF
/zig-cache
/zig-out
EOF

touch Makefile
cat > Makefile <<EOF
.PHONY: run, build, test, format, clean

run:
	@zig build run

build:
	@zig build

test:
	@zig test src/main.zig

format:
	@zig fmt **/*.zig

clean:
	@rm -rf zig-cache zig-out
EOF

