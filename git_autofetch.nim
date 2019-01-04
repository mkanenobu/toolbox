import os, osproc, ospaths, strformat, times
import sequtils, strutils

const interval = 600  # second

var
  (gitRoot, exitCode) = execCmdEx("git rev-parse --show-toplevel")

if exitCode != 0:
  quit 0

let
  cacheDir: string = getHomeDir() & ".cache/"
  cacheFilePath: string = cacheDir & "git_autofetch"
  currentTime: int = int(epochTime())

gitRoot = gitRoot.splitLines[0]

var
  cacheFile: File
  cachedGitRoot, cacheTime: string
  tmp1: string = ""
  tmp2: string = ""
  isCached: bool = false
  spendTime: int

proc main() =
  if existsFile(cacheFilePath):
    tmp1 = readFile(cacheFilePath)
  else:
    # create file
    var createF = open(cacheFilePath, FileMode.fmWrite)
    createF.close()

  if tmp1 != "":
    for i in splitLines(tmp1):
      if i == "":
        continue
      if i.split(",")[1] == gitRoot:
        isCached = true
        spendTime = currentTime - parseInt(i.split(',')[0])
        if currentTime - parseInt(i.split(',')[0]) >= interval:
          # echo fmt"Exec git fetch ({spendTime})"
          discard execShellCmd("(git fetch & 1>/dev/null 2>/dev/null)")
          tmp2 &= fmt"{currentTime},{gitRoot}" & '\n'
        else:
          tmp2 &= i & '\n'
      else:
        tmp2 &= i & '\n'

  if not isCached:
    tmp2 &= fmt"{currentTime},{gitRoot}" & '\n'

  cacheFilePath.writeFile(tmp2)

if isMainModule:
  main()
