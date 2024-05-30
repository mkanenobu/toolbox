#!/usr/bin/env node

const readline = require("readline");

const main = () => {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false,
  });

  rl.on("line", (line) => {
    try {
      console.log(JSON.stringify(JSON.parse(line), null, 2));
    } catch (e) {
      console.error("Invalid JSON:", line);
    }
  });
};

main();
