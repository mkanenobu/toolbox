#!/usr/bin/env node

const loadStdin = async () => {
  const buf = [];
  for await (const chunk of process.stdin) {
    buf.push(chunk);
  }
  const b = Buffer.concat(buf);
  return b.toString("utf-8");
}

const main = async () => {
  const formatter =  new Intl.NumberFormat("ja-JP",{ 
    notation: "compact",
  });

  const printFormatted = (n) => {
    console.log(formatter.format(n));
  }

  var numbers;
  if (process.stdin.isTTY) {
    numbers = process.argv.slice(2);
  } else {
    const stdin = await loadStdin();
    numbers = stdin.split(/\s+/);
  }

  numbers.forEach((arg) => {
    if (!arg) {
      return;
    }

    try {
      // FIXME: 指数表記に未対応
      const n = BigInt(arg);
      printFormatted(n)
    } catch (error) {
      console.error(error);
    }
  });
};
main();
