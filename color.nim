import os, system, strutils, sequtils, re
import strformat, sugar

proc exec(arg: string): int =
  execShellCmd("pastel color " & arg)

proc main(): int =
  let args: seq[string] = commandLineParams()

  if args.len == 3:
    let formattedArgs = args.mapIt(it.replace(",")).join(",")
    return exec(fmt"""'rgb({formattedArgs})'""")
  elif args.len == 1:
    let splitted = args[0].split(",")
    if splitted.len == 3 and splitted.all((arg: string) => arg.match(re"\d")):
      return exec(fmt"""'rgb({args[0]})'""")
    else:
      return exec(fmt"'{args[0]}'")
  else:
    return exec(args.join(" "))

quit main()
