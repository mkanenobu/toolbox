#!/usr/bin/env ruby

def get_input
  if STDIN.tty?
    input = ARGV
  else
    input = STDIN.gets.chomp.split(/\s+/)
  end
  input
end

def approximate_japanese_number(number, significant_digits = 1)
  case number.abs
  when 0 then '0'
  when 1 then '1'
  when 1e+4..Float::INFINITY
    scales = {
      1e+44 => '載',
      1e+40 => '正',
      1e+36 => '澗',
      1e+32 => '溝',
      1e+28 => '穣',
      1e+24 => '𥝱',
      1e+20 => '垓',
      1e+16 => '京',
      1e+12 => '兆',
      1e+8 => '億',
      1e+4 => '万',
    }

    scales.each do |value, unit|
      if number >= value
        n = (number / value).round(significant_digits)
        return n.to_s + unit
      elsif number <= -value
        n = (-number / value).round(significant_digits)
        return "-" + n.to_s + unit
      end
    end
  else
    number.to_s
  end
end

input = get_input
input.each do |num|
  n = eval(num).to_f
  puts "#{approximate_japanese_number n}\n#{sprintf("%.1e", n)} "
end

