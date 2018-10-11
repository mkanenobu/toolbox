# Copyright 2018 kanenobu mitsuru

# for linux
# show system avairable fonts
import sequtils, strutils, osproc, algorithm, sets

var installedFonts:seq[string] = execProcess("/usr/bin/fc-list").splitLines
# remove blank line
discard installedFonts.pop

for i, font in installedFonts:
  installedFonts[i] = font.split(':')[1]

installedFonts = deduplicate(installedFonts)
installedFonts.sort(cmp)

for font in installedFonts:
  echo font.strip
