import { expect, test } from "bun:test";
import { parseCommandLineArgs } from "./cli.ts";

test("parseCommandLineArgs", () => {
  let res = parseCommandLineArgs(["-f"]);
  expect(res.values).toEqual({
    "follow-symlink": true,
    verbose: false,
    help: false,
  });
  expect(res.positionals).toEqual([]);

  res = parseCommandLineArgs(["aaa/test.txt"]);
  expect(res.values).toEqual({
    "follow-symlink": false,
    verbose: false,
    help: false,
  });
  expect(res.positionals).toEqual(["aaa/test.txt"]);

  res = parseCommandLineArgs(["file", "--follow-symlink"]);
  expect(res.values).toEqual({
    "follow-symlink": true,
    verbose: false,
    help: false,
  });
  expect(res.positionals).toEqual(["file"]);

  res = parseCommandLineArgs(["--follow-symlink", "file"]);
  expect(res.values).toEqual({
    "follow-symlink": true,
    verbose: false,
    help: false,
  });
  expect(res.positionals).toEqual(["file"]);
});
