#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys

args = sys.argv

s = ""

if len(args) == 1:
    s = input("Please input:")
else:
    s = args[1]

for arg in s:
    for i in arg:
        print(format(ord(i), 'x').upper(), end=" ")

print("")
