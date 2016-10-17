#!/usr/bin/env python3

import sys
import csv

"""
Field  Name            Full name           Format          Example
1      SEQ             Sequence number     Int (6)         86415
2      KM_REF          Kilometre reference Char (6)        ST5265
3      DEF_NAM         Definitive name     Char (60)       Felton
4      TILE_REF        Tile reference      Char (4)        ST46
5      LAT_DEG         Latitude degrees    Int (2)         51
6      LAT_MIN         Latitude minutes    Float (3.1)     23.1
7      LONG_DEG        Longitude degrees   Int (2)         2
8      LONG_MIN        Longitude minutes   Float (3.1)     41
9      NORTH           Northings           Int (7)         165500
10     EAST            Eastings            Int (7)         352500
11     GMT             Greenwich Meridian  Char (1)        W
12     CO_CODE         County code         Char (2)        NS
13     COUNTY          County name         Char (20)       N Som
14     FULL_COUNTY     Full county name    Char (60)       North Somerset
15     F_CODE          Feature code        Char (3)        O
16     E_DATE          Edit date           Char (11)       01-MAR-1993
17     UPDATE_CO       Update code         Char (1)        l
18     SHEET_1         Primary sheet no    Int (3)         172
19     SHEET_2         Second sheet no     Int (3)         182
20     SHEET_3         Third sheet no      Int (3)         0
"""

county = {}

for row in csv.reader(sys.stdin, delimiter=':', quoting=csv.QUOTE_NONE):

    county[row[11]] = {
        'gaz50k': row[11],
        'county': row[12],
        'name': row[13],
    }

fields = [ 'gaz50k', 'county', 'name' ]
print("\t".join(fields))
for code in county:
    print("\t".join([county[code][field] or "" for field in fields]))
