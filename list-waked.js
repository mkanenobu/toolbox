#!/usr/bin/env node

const spawn = require("node:child_process").spawn;
const process = require("node:process");
const readline = require("node:readline");

const parseLine = (line) => {
  const [dtAndType, ...rest] = line.split("  ");
  const [date, time, tz, eventType] = dtAndType.split(" ");
  const dt = new Date(`${date} ${time} ${tz}`);
  return {
    dt,
    eventType,
    log: rest.join(" ").trim(),
  }
}

const dateFormatter = new Intl.DateTimeFormat("ja-JP", {
  year: "numeric",
  month: "2-digit",
  day: "2-digit",
  hour: "2-digit",
  minute: "2-digit",
  second: "2-digit",
  timeZone: "Asia/Tokyo"
});
const formatToDisplay = (event) => {
  return `${dateFormatter.format(event.dt)} ${event.eventType.padEnd(6, " ")} - ${event.log}`;
}

const outputEvents = [
  "Sleep",
  "Wake",
];

/**
 * macOSのスリープからの復帰履歴を表示する
 */
const main = async () => {
  const ps = spawn("pmset", ["-g", "log"], { stdio: ["ignore", "pipe", "pipe"] });
  ps.stderr.on("data", chunk => {
    process.stderr.write(chunk);
  });


  const rl = readline.createInterface({ input: ps.stdout, terminal: false });

  const parsedLines = [];
  rl.on("line", (line) => {
    if (line.includes("Entering Sleep") || line.includes("Wake from")) {
      const parsedLine = parseLine(line)
      if (
        outputEvents.includes(parsedLine.eventType)
        && !(parsedLine.log.includes("Maintenance Sleep") || parsedLine.log.includes("Sleep Service Back to Sleep"))
      ) {
        parsedLines.push(parsedLine);
      }
    }
  })

  const { code } = await new Promise((resolve) => ps.on("close", c => resolve({ code: c })));
  if (code !== 0) {
    throw new Error(`exit ${code}`);
  }

  console.log("Wake/Sleep Events:");
  console.log(parsedLines.length);
  parsedLines.forEach(event => console.log(formatToDisplay(event)));
}
main();
