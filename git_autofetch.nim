import os, osproc, ospaths, strformat, times
import sequtils, strutils

const interval = 3600  # second

var
  (gitRoot, exitCode) = execCmdEx("git rev-parse --show-toplevel")

if exitCode != 0:
  quit 0

let
  cacheDir = getHomeDir() & ".cache/"
  cacheFilePath = cacheDir & "git_autofetch"
  tmpFilePath = cacheDir & "git_autofetch.tmp"
  currentTime: int = int(epochTime())

gitRoot = gitRoot.splitLines[0]

var
  cacheFile, tmpFile: File
  cachedGitRoot, cacheTime: string
  cachedFlg: bool = false

proc main() =
  if not existsFile(cacheFilePath):
    echo "Create cache file and this directory added to cache"
    cacheFile = open(cacheFilePath, FileMode.fmWrite)
    cacheFile.writeLine(fmt"{currentTime},{gitRoot}")
  else:
    cacheFile = open(cacheFilePath, FileMode.fmRead)
    defer: close(cacheFile)
    tmpFile = open(tmpFilePath, FileMode.fmWrite)
    defer: close(tmpFile)

    for i in lines(cacheFile):
      if i.split(",")[1] != gitRoot:
        tmpFile.writeLine(i)
      else:
        cachedFlg = true
        if currentTime - parseInt(i.split(",")[0]) >= interval:
          echo "Exec git fetch"
          discard execProcess("git fetch")
          tmpFile.writeLine(fmt"{currentTime},{gitRoot}")
        else:
          tmpFile.writeLine(i)

    if not cachedFlg:
      echo "Exec git fetch and added to cache"
      tmpFile.writeLine(fmt"{currentTime},{gitRoot}")

    if existsFile(tmpFilePath):
      moveFile(tmpFilePath, cacheFilePath)

main()
