import tables, sequtils, strutils, os

type QueryString = string

let settingFile: string = if getEnv("XDG_CONFIG_HOME") != "":
  getEnv("XDG_CONFIG_HOME") & "/gg-setting.csv"
else:
  getEnv("HOME") & "/.config/gg-setting.csv"


proc buildQuery*(searchString: string, query: QueryString): string =
  query.replace("%s", searchString)

