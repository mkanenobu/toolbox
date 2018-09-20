#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys

args = sys.argv
s = ' '.join(args[1:])
s = s.replace('^', '**')

print(eval(s))
