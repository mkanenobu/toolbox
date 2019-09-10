# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import ggpkg/openBrowser
import os, strutils, sequtils, uri

when isMainModule:
  let searchString: string = commandLineParams().join(" ").encodeUrl
  search(searchString)
