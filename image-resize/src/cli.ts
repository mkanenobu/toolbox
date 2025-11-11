import { parseArgs } from "node:util";

export const parseArguments = (args: string[]) => {
  const { values, positionals } = parseArgs({
    args,
    allowPositionals: true,
    options: {
      output: {
        type: "string",
        short: "o",
      },
      scale: {
        type: "string",
        short: "s",
      },
    },
  });

  if (positionals.length === 0) {
    throw new Error("At least one input file must be specified.");
  }
  if (!values.scale) {
    throw new Error("Scale parameter is required.");
  }

  return {
    filepaths: positionals,
    output: values.output || ".",
    scale: parseScale(values.scale),
  };
};

/**
 * ex) "0.5" -> 1.5, "1/2" -> 0.5, 50% -> 0.5
 */
const parseScale = (scale: string): number => {
  let scaleValue = 1;
  if (scale.endsWith("%")) {
    scaleValue = parseFloat(scale.slice(0, -1));
  } else if (scale.includes("/")) {
    const parts = scale.split("/");
    if (parts.length !== 2) {
      throw new Error(`Invalid scale format: ${scale}`);
    }
    const [numerator, denominator] = parts;
    scaleValue = parseFloat(numerator!) / parseFloat(denominator!);
  } else if (!isNaN(Number(scale))) {
    scaleValue = parseFloat(scale);
  }

  return scaleValue;
};
