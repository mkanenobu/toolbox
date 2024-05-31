#!/usr/bin/env bash

zig init

touch .gitignore
cat > .gitignore <<EOF
/zig-cache
/zig-out
EOF

touch Makefile
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
	@rm -rf zig-cache zig-out
EOF

cat >> src/main.zig <<EOF

comptime {
    std.testing.refAllDecls(@This());
}
EOF

