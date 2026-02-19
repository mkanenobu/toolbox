#!/usr/bin/env node

const spawn = require("node:child_process").spawn;

const WAIT_MINUTES = 15;

const escape = (str) => {
  return str.replace(/\\/g, "\\\\")
}

const main = async () => {
  const message = process.argv.slice(2).join(" ");
  if (!message) {
    console.error("message required");
    process.exit(1);
  }

  const cmd = `
sleep ${WAIT_MINUTES * 60}
osascript -e 'display notification "${escape(message)}" with title "Reminder"'
`.trim();

  spawn("sh", ["-c", cmd], {
    detached: true,
    stdio: "ignore",
  }).unref();

  console.log(`Reminder set: "${message}" (after ${WAIT_MINUTES} minutes)`);
};
main();
