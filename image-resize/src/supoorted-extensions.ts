export const supportedExtensions = [".jpg", ".jpeg", ".png"] as const;

export const isSupportedExtension = (filename: string): boolean => {
  const lowercasedFilename = filename.toLowerCase();
  return supportedExtensions.some((ext) => lowercasedFilename.endsWith(ext));
};
