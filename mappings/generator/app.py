import argparse
from rdflib import Graph

g = Graph()
g.parse("../gtfs-csv.rml.ttl", format="ttl")



parser = argparse.ArgumentParser(description='Generate multisource mapping file')
parser.add_argmuent('--config-file', dest='in_config', required=True)
parser.add_argument('--input-mapping', dest='in_mapping', required=True)
parser.add_argument('--output-mapping', dest='out_mapping', required=True)


args = parser.parse_args()

import pprint
for stmt in g:
    pprint.pprint(stmt)
