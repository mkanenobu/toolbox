import os, std/sha1, unicode

var hashText = ""

for f in walkDirRec("."):
  hashText &= $secureHashFile(f)

echo ($secureHash(hashText)).toLower
