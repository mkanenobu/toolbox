import * as path from "node:path";

const escapeScaleToString = (scale: number): string => {
  if (Number.isInteger(scale)) {
    return scale.toString();
  } else {
    return scale.toFixed(2).replace(".", "p").replace(/0+$/, "");
  }
};

export const outputPath = (
  outputDir: string,
  inputFilePath: string,
  scale: number,
): string => {
  const inputFileName = path.basename(inputFilePath);
  const ext = path.extname(inputFileName);
  const baseName = path.basename(inputFileName, ext);
  const scaleStr = escapeScaleToString(scale);
  const outputFileName = `${baseName}_${scaleStr}${ext}`;
  return path.join(outputDir, outputFileName);
};
