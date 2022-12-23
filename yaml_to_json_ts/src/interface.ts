import fs from "https://deno.land/std@0.98.0/node/fs.ts";
import { exists } from "https://deno.land/std@0.98.0/fs/exists.ts";

const tryToReadFile = async (filename: string): Promise<string> => {
  if (await exists(filename)) {
    return fs.readFileSync(filename, "utf-8");
  }
  throw new Error("Not exists file.");
};

const readStdin = async (): Promise<string> =>
  new TextDecoder().decode(await Deno.readAll(Deno.stdin));

export const getSourceYamlString = async (): Promise<string> => {
  const { args } = Deno;
  const filename = args[0];
  if (filename) {
    return tryToReadFile(filename);
  }

  return await readStdin();
};
