import { parseArguments } from "./cli.ts";
import * as fs from "node:fs/promises";
import { isSupportedExtension } from "./supoorted-extensions.ts";
import { outputPath } from "./output-path.ts";
import { resizeImage } from "./resize-image.ts";

export const main = async () => {
  const args = parseArguments(process.argv.slice(2));

  // cheek input files
  const filepaths = await Promise.all(
    args.filepaths.map(async (filepath) => {
      if (!isSupportedExtension(filepath)) {
        throw new Error(`Unsupported file extension: ${filepath}`);
      }

      const data = await fs.stat(filepath);
      if (!data.isFile()) {
        throw new Error(`Input file does not exist: ${filepath}`);
      }

      return {
        filepath,
        outputPath: outputPath(args.output, filepath, args.scale),
      };
    }),
  );

  await Promise.all(
    filepaths.map(async ({ filepath, outputPath }) => {
      // perform resize operation
      await resizeImage(filepath, outputPath, args.scale);
      console.log(`Resized image saved to: ${outputPath}`);
    }),
  );
};
