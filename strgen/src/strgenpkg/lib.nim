import random, sequtils, strutils

proc takeRandomNChars(source: seq[string], n: int): string =
  randomize()

