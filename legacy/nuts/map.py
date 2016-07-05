#!/usr/bin/env python3

import sys
import csv

# "Order";"Level";"Code";"Parent";"NUTS-Code";"Description";"Remark"

print("\t".join([ 'nuts', 'name' ]))

for row in csv.DictReader(sys.stdin):
    if row['Parent'] == '1713':
        print("\t".join([row['NUTS-Code'], row['Description']]))
