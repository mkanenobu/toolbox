import sharp from "sharp";

export const resizeImage = async (
  filepath: string,
  outputPath: string,
  scale: number,
): Promise<void> => {
  const s = sharp(filepath);
  const metadata = await s.metadata();
  await s
    .toFormat(metadata.format, { quality: 70 })
    .resize(metadata.width * scale, metadata.height * scale)
    .toFile(outputPath);
};
