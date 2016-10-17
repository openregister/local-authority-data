#!/usr/bin/env python3

import sys
import csv

# Name,Home page URL,Contact page URL,SNAC Code,Address Line 1,Address Line 2,Town,City,County,Postcode,Telephone Number 1 Description,Telephone Number 1,Telephone Number 2 Description,Telephone Number 2,Telephone Number 3 Description,Telephone Number 3,Fax,Main Contact Email,Opening Hours

print("\t".join([ 'snac', 'name', 'website' ]))

reader = csv.DictReader(sys.stdin)

for row in reader:
    print("\t".join([ row['SNAC Code'], row['Name'], row['Home page URL'] ]))
