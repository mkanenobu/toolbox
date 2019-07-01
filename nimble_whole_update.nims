#!/usr/bin/env nim

mode = ScriptMode.Silent

import strutils, sequtils, strformat

let (output1, exit_code1) = gorgeEx("nimble update")
if exit_code1 != 0:
  echo output1
  quit 1
let (output2, exit_code2) = gorgeEx("nimble list --installed")
if exit_code2 != 0:
  echo output2
  quit 2

let out_lines = splitLines(output2)
let update_available_packages = out_lines.mapIt(it.split[0])
                                         .filter(proc(x: string): bool = x != "")

if update_available_packages.len == 0:
  echo "Packages are not found"
  quit 3

echo "Update following packages"
echo "$1" % [update_available_packages.join(", ")]

var error_count = 0

for package in update_available_packages:
  let (_, exit_code) = gorgeEx(fmt"nimble -y install {package}")
  if exit_code != 0:
    echo fmt"Update failed  {package}"
    error_count += 1
  else:
    echo fmt"Update success {package}"

if error_count != 0:
  echo fmt"Error {error_count} packages"
else:
  echo "Done"

