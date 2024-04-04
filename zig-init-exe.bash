#!/usr/bin/env bash

zig init-exe

touch .gitignore
cat > .gitignore <<EOF
/zig-cache
/zig-out
EOF

touch Makefile
cat > Makefile <<EOF
.PHONY: build, run, test, format, clean

build:
	@zig build

run:
	@zig build run

test:
	@zig test src/*.zig

format:
	@zig fmt **/*.zig

clean:
	@rm -rf zig-cache zig-out
EOF

