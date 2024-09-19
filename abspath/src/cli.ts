import { parseArgs, type ParseArgsConfig } from "node:util";

const argsOptions = {
  "follow-symlink": {
    type: "boolean",
    short: "f",
    default: false,
  },
  verbose: {
    type: "boolean",
    default: false,
  },
  help: {
    type: "boolean",
    default: false,
  },
} satisfies ParseArgsConfig["options"];

export const parseCommandLineArgs = (args: string[]) => {
  return parseArgs({
    args,
    allowPositionals: true,
    options: argsOptions,
  });
};

export const help = `
Usage: abspath [OPTIONS] <PATH>

Options:  
  -f, --follow-symlink  Follow symlink
  --verbose             Print debug logs
  --help                Show this help message
  `.trim();
