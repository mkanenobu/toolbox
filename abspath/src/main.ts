import { parseCommandLineArgs } from "./cli.ts";
import process from "node:process";
import { getAbsPath } from "./get-abspath.ts";
import { Logger } from "./logger.ts";
import { help } from "./cli.ts";

const logger = new Logger();

const main = async () => {
  const args = parseCommandLineArgs(process.argv.slice(2));

  logger.verbose = !!args.values.verbose;
  logger.debug(args);

  if (args.values.help) {
    console.log(help);
    process.exit(0);
  }

  const path = args.positionals.at(0);
  if (!path) {
    console.error("");
    process.exit(1);
  }

  const abspath = await getAbsPath({
    cwd: process.cwd(),
    path,
    followSymlink: !!args.values["follow-symlink"],
  });
  console.log(abspath);
};

await main();
