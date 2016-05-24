#!/usr/bin/env python3

import sys
import csv

la = {}

reader = csv.DictReader(sys.stdin)

for row in reader:
    la[row['LA (code)']] = row['LA (name)']

print("\t".join([ 'code', 'name' ]))
for code in sorted(la):
    if code != '000':
        print("\t".join([code, la[code]]))
