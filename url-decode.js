#!/usr/bin/env -S deno run

let str = Deno.args[0];
if (!str || str.length === 0) {
  const decoder = new TextDecoder();
  let buf = "";
  for await (const chunk of Deno.stdin.readable) {
    buf += decoder.decode(chunk);
  }
  str = buf;
}

console.log(decodeURIComponent(str))

