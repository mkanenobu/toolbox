import fs from "node:fs/promises";
import path from "node:path";

export const getAbsPath = async ({
  cwd,
  path: _path,
  followSymlink,
}: {
  cwd: string;
  path: string;
  followSymlink: boolean;
}): Promise<string> => {
  let absPath = _path;
  if (!path.isAbsolute(_path)) {
    absPath = path.join(cwd, _path);
  }

  if (followSymlink) {
    const stat = await fs.stat(absPath).catch(() => null);
    if (stat?.isSymbolicLink()) {
      return await fs.realpath(absPath);
    }
  }

  return path.normalize(absPath);
};
