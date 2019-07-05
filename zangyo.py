#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
from datetime import datetime

# WIP
if len(sys.argv) < 2:
    sys.exit(1)

print(sys.argv[1])

arg1 = sys.argv[1]
syukkin_time = datetime.time.strptime(arg1, '%H%M')
now = datetime.now()

work = now - syukkin_time
print(work)
