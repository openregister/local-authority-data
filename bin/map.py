#!/usr/bin/env python

"""
merge a number of different existing codes
for local authorities into a single map

TBD: there's a lot more lists,
so split dataset specific wranging into each lists Makefile
"""

import csv

synonyms = {
    'CITY OF ABERDEEN': 'ABERDEEN CITY',
    'DUNDEE CITY': 'CITY OF DUNDEE',
    'GLASGOW CITY': 'CITY OF GLASGOW',
    'BRISTOL': 'CITY OF BRISTOL',
    'BRISTOL, CITY OF': 'CITY OF BRISTOL',
    'DURHAM': 'COUNTY DURHAM',
    'HEREFORDSHIRE, COUNTY OF': 'HEREFORDSHIRE',
    'KINGSTON UPON HULL, CITY OF': 'KINGSTON UPON HULL',
    'SCOTTISH BORDERS': 'THE SCOTTISH BORDERS',
    'WORCESTER': 'WORCESTERSHIRE',
    'CITY OF WESTMINSTER': 'WESTMINSTER',
    'CITY OF STOKE-ON-TRENT': 'STOKE-ON-TRENT',
    'KINGS LYNN AND WEST NORFOLK': 'KING\'S LYNN AND WEST NORFOLK',
    'VALE OF GLAMORGAN': 'THE VALE OF GLAMORGAN'
}

skip_type_labels = [
    'Fire Authority',
    'Police Authority',
    'Waste Authority',
    'National Park Authority',
    'Transport Authority'
]


class CodeMap(object):
    def __init__(self):
        self.keys = {}

    def add(self, name):
        key = name.upper()
        key = synonyms.get(key, key)
        if key not in self.keys:
            self.keys[key] = {}
        if 'name' not in self.keys[key]:
            self.keys[key]['name'] = name
        return key

    def load_register(self, path):
        reader = csv.DictReader(open(path, 'r'), delimiter='\t')
        for row in reader:
            key = self.add(row['name'])
            self.keys[key]['local-authority'] = row['local-authority']
            self.keys[key]['uk'] = row['uk']

    def load_communities(self, path):
        reader = csv.DictReader(open(path, 'r'), delimiter='\t')
        for row in reader:
            if row['LA_Type_Label'] not in skip_type_labels:
                key = self.add(row['Local_Authority_Name'])
                self.keys[key]['ons'] = row['ONS_Code']

    def load_custodians(self, path):
        reader = csv.DictReader(open(path, 'r'), delimiter='\t')
        for row in reader:
            key = self.add(row['name'])
            self.keys[key]['local-custodian'] = row['local-custodian']

    def dump(self):
        print("%s\t%s\t%s\t%s\t%s\t%s" % (
            'local-authority',
            'uk',
            'ADMINISTRATIVE-AREA',
            'name',
            'ons',
            'local-custodian'
        ))

        for key in self.keys:
            row = self.keys[key]
            print("%s\t%s\t%s\t%s\t%s\t%s" % (
                row.get('local-authority', '#'),
                row.get('uk', ''),
                key,
                row.get('name', ''),
                row.get('ons', ''),
                row.get('local-custodian', ''),
            ))

if __name__ == '__main__':
    codes = CodeMap()
    codes.load_register('data/local-authority/local-authorities.tsv')
    codes.load_custodians('lists/geoplace/local-custodian.tsv')
    codes.load_communities('lists/opendatacommunities/opendatacommunities.tsv')
    codes.dump()
