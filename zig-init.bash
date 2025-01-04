#!/usr/bin/env bash

set -Ceu

zig init

cat > .gitignore <<EOF
/.zig-cache
/zig-out
EOF

cat > Makefile <<EOF
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

EOF

cat > .editorconfig <<EOF
root = true

[*]
end_of_line = lf
insert_final_newline = true

[*.zig]
indent_style = space
indent_size = 4

EOF

