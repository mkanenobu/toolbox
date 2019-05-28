#!/usr/bin/env python3
### Like pwgen

import string
import random
import sys
import subprocess

def generate(start, end, length):
    res = ""
    for i in range(length):
        res += string.printable[random.randrange(start, end)]
    return res

args = sys.argv[1:]

start = 0
end = 61
length = 8

# no numbers
if "-0" in args:
    start = 10
    args.remove("-0")

# numbers only
if "-n" in args:
    end = 10
    args.remove("-n")

# no upper case
if "-A" in args:
    end = 35
    args.remove("-A")

# include symbols
if "-y" in args:
    end = 94
    args.remove("-y")

if "-h" in args:
    print("""
-0  No numbers
-n  Numbers only
-A  No upper case
-y  Include symbols
-h  Show this help
""")
    sys.exit()

if len(args) > 0:
    length = int(args[0])

def write_to_clipboard(output):
    process = subprocess.Popen(
        'pbcopy', env={'LANG': 'en_US.UTF-8'}, stdin=subprocess.PIPE)
    process.communicate(output.encode('utf-8'))

generated = generate(start, end, length)

print(generated)
write_to_clipboard(generated)

