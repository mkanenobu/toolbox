import { expect, test } from "bun:test";
import { getAbsPath } from "./get-abspath.ts";

test("getAbsPath", async () => {
  const testCases = [
    {
      cwd: "/usr/bin/",
      path: "test.txt",
      followSymlink: false,
      expected: "/usr/bin/test.txt",
    },
    {
      cwd: "/usr/lib/",
      path: "/etc/schema.sql",
      followSymlink: false,
      expected: "/etc/schema.sql",
    },
    {
      cwd: "/usr/lib/",
      path: "../etc/schema.sql",
      followSymlink: false,
      expected: "/usr/etc/schema.sql",
    },
  ] satisfies Array<{
    cwd: string;
    path: string;
    followSymlink: boolean;
    expected: string;
  }>;

  for (const [i, { cwd, path, followSymlink, expected }] of Object.entries(
    testCases,
  )) {
    const res = await getAbsPath({ cwd, path, followSymlink });
    expect(res, `case ${i}`).toEqual(expected);
  }
});
