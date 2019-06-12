#!/usr/bin/env python3
# Like pwgen

import random
import string
import subprocess
import sys


def generate(printable_chars, length):
    res = ""
    for i in range(length):
        res += printable_chars[random.randint(0, len(printable_chars))]
    return res


def dict_flatten(dictionary):
    # has string values
    res = []
    for i in dictionary:
        res += dictionary[i]
    return ''.join(res)


def write_to_clipboard(output):
    process = subprocess.Popen(
        'pbcopy', env={'LANG': 'en_US.UTF-8'}, stdin=subprocess.PIPE)
    process.communicate(output.encode('utf-8'))


args = sys.argv[1:]

printable_chars_dict = {
    "upper_ascii": string.ascii_uppercase,
    "lowwer_ascii": string.ascii_lowercase,
    "digits": string.digits,
}

length = 8


def parse_args(printable_chars_dict):
    # no numbers
    if "-0" in args:
        del printable_chars_dict["digits"]
        args.remove("-0")
        return printable_chars_dict

    # numbers only
    if "-n" in args:
        printable_chars_dict = {"digits": string.digits}
        args.remove("-n")
        return printable_chars_dict

    # no upper case
    if "-A" in args:
        del printable_chars_dict["upper_ascii"]
        args.remove("-A")
        return printable_chars_dict

    # include symbols
    if "-y" in args:
        printable_chars_dict["symbols"] = string.punctuation
        args.remove("-y")
        return printable_chars_dict

    # japanese only
    if "-j" in args:
        printable_chars_dict = {
            "hiragana": [chr(i) for i in range(ord('ぁ'), ord('ん'))],
            "katakana": [chr(i) for i in range(ord('ァ'), ord('ン'))],
            # 適当に100個
            "kanji": [chr(i) for i in range(ord('亜'), 20224)],
        }
        args.remove("-j")
        return printable_chars_dict

    if "-h" in args:
        print("""
    -0  No numbers
    -n  Numbers only
    -A  No upper case
    -y  Include symbols
    -h  Show this help
    -j  Japanese only
    """)
        sys.exit()


printable_chars_dict = parse_args(printable_chars_dict)

if len(args) > 0:
    length = int(args[-1])


generated = generate(dict_flatten(printable_chars_dict), length)

print(generated)
write_to_clipboard(generated)
