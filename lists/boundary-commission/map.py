#!/usr/bin/env python3

import sys
import openpyxl

types = {
    'Two-Tier County': 'two-tier county',
    'Two-Tier District': 'two-tier district',
    'Unitary County': 'unitary county',
    'Unitary District': 'unitary district',
    'London Borough': 'London borough',
    'Metropolitan District': 'metropolitan district'
}

wb = openpyxl.load_workbook(sys.argv[1])
sh = wb.active

print("\t".join(['name', 'local-authority-category', 'parent-name']))

for r in sh.rows:
    if not r[0].value in ['', 'Last updated', 'Authority Name']:
        name = r[0].value
        authority_type = types[r[7].value]
        council_name = r[8].value
        if council_name == 'n/a':
            council_name = ''

        print("\t".join([name, authority_type, council_name]))
