#!/usr/bin/env python3

import csv
import sys

cols = [ 'local-authority', 'uk', 'local-authority-type', 'parent-local-authority', 'name', 'name-cy', 'official-name', 'website', 'start-date', 'end-date', 'snac' ]

def merge(d, s):
    if not d:
        d = {}
    for col in cols:
        if col in s and s[col] != '':
            d[col] = s[col]
        if col not in d:
            d[col] = ''
    return d



snacs = {}
reader = csv.DictReader(open('snac.tsv'), delimiter='\t')
for row in reader:
    snac = row['snac']
    snacs[snac] = merge(row, {})


las = {}
reader = csv.DictReader(open('iso.tsv'), delimiter='\t')
for row in reader:
    la = row['local-authority']
    snac = row['snac']

    if snac:
        row = merge(row, snacs[snac])
        del snacs[snac]

    las[la] = merge(row, {})


# merge
for la in las:
    if not las[la]['snac']:
        for snac in sorted(snacs):
            if snacs[snac]['official-name'].startswith(las[la]['name']) or snacs[snac]['official-name'].startswith("London Borough of " + las[la]['name']):
                las[la] = merge(las[la], snacs[snac])
                del snacs[snac]

for snac in snacs:
    las[snac] = snacs[snac]

# snac lookups
snacs = {}
for la in las:
    if 'snac' in las[la]:
        snacs[las[la]['snac']] = las[la].get('local-authority', snac)


for la in las:
    if not las[la]['parent-local-authority']:
        if las[la]['snac']:
            p = las[la]['snac'][:2]
            if p != "00":
                if p in snacs:
                    las[la]['parent-local-authority'] = snacs[p]

            if p == "95":
                las[la]['uk'] = 'NIR'
                las[la]['local-authority'] = "NIR" + "-" + las[la]['snac'][2:]

            if p in snacs:
                if not las[la]['local-authority']:
                    las[la]['local-authority'] = snacs[p] + "-" + las[la]['snac'][2:]

for la in las:
    code = las[la]['local-authority']
    if la != code:
        las[code] = las[la]
        del las[la]

for la in las:
    if not las[la]['parent-local-authority']:
        if las[la]['local-authority-type'] == 'LBO':
            las[la]['parent-local-authority'] = "GLA"

    if not las[la]['uk']:
        if las[la]['parent-local-authority']:
            las[la]['uk'] = las[las[la]['parent-local-authority']].get('uk', '')



# print out las
print("\t".join(cols))
for la in sorted(las, key=lambda k: (las[k].get('uk', ''), las[k].get('parent-local-authority', ''), las[k].get('parent-local-authority', ''))):
    print("\t".join([las[la].get(col, "") for col in cols]))
