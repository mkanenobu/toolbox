#!/usr/bin/env ruby

def changed_files(base_commit = nil)
  head_branch = `git ls-remote origin HEAD`.split.first
  base_commit = `git merge-base #{head_branch} HEAD`.strip unless base_commit
  output = `git diff #{base_commit} --staged --diff-filter=AM --name-only`
  output.strip.split("\n")
end

changed_files.each do |file|
  puts file
end
