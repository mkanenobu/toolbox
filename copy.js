#!/usr/bin/env node

import process from "node:process";
import childProcess  from "node:child_process";

const readStdin = async () => {
  let buf = "";
  for await (const chunk of process.stdin) {
    buf += Buffer.from(chunk).toString();
  }
  return buf;
};

const pbcopy = (data) => {
  const proc = childProcess.spawn("pbcopy");
  proc.stdin.write(data);
  proc.stdin.end();
}

/**
 * Copy trimmed stdin to clipboard, and print to stdout
 */
const main = async () => {
  if (process.stdin.isTTY) {
    return;
  }

  const input = await readStdin();
  const trimmed = input.trim();

  pbcopy(trimmed);
  console.log(trimmed);
};
main();