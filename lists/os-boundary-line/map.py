#!/usr/bin/env python3

import sys
import csv

la = {}

# NAME,AREA_CODE,DESCRIPTIO,FILE_NAME,NUMBER,NUMBER0,POLYGON_ID,UNIT_ID,CODE,HECTARES,AREA,TYPE_CODE,DESCRIPT0,TYPE_COD0,DESCRIPT1
for filename in ['county.csv', 'district.csv']:
    reader = csv.DictReader(open(filename))
    for row in reader:
        la[row['CODE']] = { 'name': row['NAME'], 'type': row['AREA_CODE'] }

print("\t".join([ 'code', 'type', 'name' ]))
for code in sorted(la):
    print("\t".join([code, la[code]['type'], la[code]['name']]))
