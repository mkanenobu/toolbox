#!/usr/bin/env ruby

require "pathname"

# 可変項目（環境変数でも上書き可）
MAX_COLORS = Integer(ENV.fetch("MAX_COLORS", "128"))
FPS        = Integer(ENV.fetch("FPS", "10"))

def gather_inputs
  inputs = []
  inputs.concat(ARGV)

  # パイプやリダイレクトがあればstdinから1行1ファイルで追加
  unless STDIN.tty?
    STDIN.each_line do |line|
      path = line.strip
      next if path.empty?
      inputs << path
    end
  end

  inputs.map!(&:strip).reject!(&:empty?)
  inputs.uniq
end

inputs = gather_inputs

if inputs.empty?
  warn <<~USAGE
    Usage: #{File.basename($0)} input1.mov [input2.mov ...]
      or:  cat files.txt | #{File.basename($0)}
    Options via env:
      MAX_COLORS (default: 128), FPS (default: 10)
  USAGE
  exit 1
end

def transcode(input_path)
  in_path = Pathname(input_path)

  unless in_path.file?
    warn "Skip (not found): #{input_path}"
    return 2
  end

  out_path = in_path.sub_ext(".gif")

  filter = "fps=#{FPS},scale=iw/2:-1:flags=lanczos,split [a][b]; " \
           "[a]palettegen=stats_mode=single:max_colors=#{MAX_COLORS}[p]; " \
           "[b][p]paletteuse=dither=sierra2_4a"

  cmd = [
    "ffmpeg", "-y",
    "-i", in_path.to_s,
    "-filter_complex", filter,
    out_path.to_s
  ]

  ok = system(*cmd)
  unless ok
    warn "Error: ffmpeg failed -> #{in_path}"
    return 1
  end

  0
end

exit_code = 0
inputs.each do |path|
  rc = transcode(path)
  exit_code = 1 if rc == 1
end

exit exit_code
