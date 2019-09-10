import strutils, sequtils, browsers
import parseopt

proc search*(s: string) = openDefaultBrowser(s)

proc parseArgs(arguments: seq[string]) =
  var
    args = arguments.join(" ").initOptParser
    searchString = ""
  for kind, key, val in getopt(args):
    case kind
    of cmdLongOption, cmdShortOption:
      discard
    of cmdEnd:
      discard
    of cmdArgument:
      searchString &= (" " & val)
