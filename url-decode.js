#!/usr/bin/env bun

let str = Bun.argv[2];

// try to read stdin if no args
if (!str || str.length === 0) {
  let buf = "";
  for await (const chunk of Bun.stdin.stream()) {
    buf += Buffer.from(chunk).toString();
  }
  str = buf;
}

const print = (s) => {
  const nl = process.stdout.isTTY ? "\n" : "";
  process.stdout.write(s + nl);
}

print(decodeURIComponent(str));
