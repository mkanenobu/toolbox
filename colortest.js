#!/usr/bin/env node

const TEXT = "gYw";

const foregrounds = [
  "m", "1m", "30m", "1;30m", "31m", "1;31m", "32m",
  "1;32m", "33m", "1;33m", "34m", "1;34m", "35m", "1;35m",
  "36m", "1;36m", "37m", "1;37m"
];

const backgrounds = ["40m", "41m", "42m", "43m", "44m", "45m", "46m", "47m"];

process.stdout.write(`\n                 ${backgrounds.join("     ")}\n`);

foregrounds.forEach((fg) => {
  process.stdout.write(` ${fg.padStart(5, " ")} \x1b[${fg}  ${TEXT}  `);
  backgrounds.forEach((bg) => {
    process.stdout.write(` \x1b[${fg}\x1b[${bg}  ${TEXT}  \x1b[0m`);
  });
  process.stdout.write("\n");
});
