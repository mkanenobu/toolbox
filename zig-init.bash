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
	@zig test src/main.zig 2>&1 | cat
	@zig test src/root.zig 2>&1 | cat

.PHONY: fmt
fmt:
	@zig fmt \$\$(find . -name "*.zig")

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

cat >> src/main.zig <<EOF

test {
    std.testing.refAllDecls(@This());
}
EOF

cat >> src/root.zig <<EOF

test {
    std.testing.refAllDecls(@This());
}
EOF

