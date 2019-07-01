#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import codecs
import sys

if len(sys.argv) == 1:
    print("No input")
    sys.exit(1)

arg = r'\u' + sys.argv[1]
try:
    decoded = codecs.decode(arg, 'unicode-escape')
    print(decoded)
except UnicodeDecodeError:
    print("Decode error")
    print("Input number")
    sys.exit(2)
