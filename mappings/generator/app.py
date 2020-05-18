#!/usr/bin/env python3

import argparse
import re
import uuid
import json
from rdflib import Graph, URIRef, Namespace, Literal
from rdflib.namespace import XSD

rdfs = Namespace("http://www.w3.org/2000/01/rdf-schema#")
rr = Namespace("http://www.w3.org/ns/r2rml#")
rdf = Namespace("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
rml = Namespace("http://semweb.mmlab.be/ns/rml#")
ql = Namespace("http://semweb.mmlab.be/ns/ql#")
ex = Namespace("http://mapping.example.com/")
d2rq = Namespace("http://www.wiwiss.fu-berlin.de/suhl/bizer/D2RQ/0.1#")

def dump_graph(g):
	for subj, pred, obj in g:
		print(subj, pred, obj)

class Source:
	def __init__(self):
		pass
	
class CSVSource(Source):
	def __init__(self, filename):
		self.filename = filename
		self.graph = Graph()
		
	def get_graph(self, map_value):
		self.graph.add((map_value, rml.logicalSource, ex.source))
		self.graph.add((ex.source, rdf.type, rml.LogicalSource))
		self.graph.add((ex.source, rml.source, Literal(self.filename, datatype=XSD.string)))	
		self.graph.add((ex.source, rml.referenceFormulation, ql.CSV))	
			
		return self.graph
		
class XMLSource(Source):
	def __init__(self, filename):
		self.filename = filename
		self.graph = Graph()
		
	def get_graph(self, map_value):
		self.graph.add((map_value, rml.logicalSource, ex.source))
		self.graph.add((ex.source, rdf.type, rml.LogicalSource))
		self.graph.add((ex.source, rml.source, Literal(self.filename, datatype=XSD.string)))	
		self.graph.add((ex.source, rml.referenceFormulation, ql.CSV))	
			
		return self.graph
		
class JSONSource(Source):
	def __init__(self, filename):
		self.filename = filename
		self.graph = Graph()
		
	def get_graph(self, map_value):
		self.graph.add((map_value, rml.logicalSource, ex.source))
		self.graph.add((ex.source, rdf.type, rml.LogicalSource))
		self.graph.add((ex.source, rml.source, Literal(self.filename, datatype=XSD.string)))	
		self.graph.add((ex.source, rml.referenceFormulation, ql.JSONPath))
		self.graph.add((ex.source, rml.iterator, Literal("$.[*]", datatype=XSD.string)))
		
		return self.graph
		
		
class MySQLSource(Source):
	def __init__(self, connection_uri, driver, user, password, table):
		self.connection_uri = connection_uri
		self.driver = driver
		self.user = user
		self.password = password
		self.table = table
		self.graph = Graph()
		
	def get_graph(self, map_value):
		self.graph.add((map_value, rml.logicalSource, ex.source))
		self.graph.add((ex.source, rdf.type, rml.LogicalSource))
		self.graph.add((ex.source, rr.tableName, Literal(self.table, datatype=XSD.string)))
		self.graph.add((ex.source, rml.source, ex.DB_source))
		self.graph.add((ex.source, rr.sqlVersion, rr.SQL2008)) # ?
		self.graph.add((ex.DB_source, rdf.type, d2rq.Database))
		self.graph.add((ex.DB_source, d2rq.jdbcDSN, Literal(self.connection_uri, datatype=XSD.string)))
		self.graph.add((ex.DB_source, d2rq.jdbcDriver, Literal(self.driver, datatype=XSD.string)))
		self.graph.add((ex.DB_source, d2rq.username, Literal(self.user, datatype=XSD.string)))
		self.graph.add((ex.DB_source, d2rq.password, Literal(self.password, datatype=XSD.string)))

		return self.graph

class MongoSource(Source):
	def __init__(self, connection_uri, user, password, table):
		self.connection_uri = connection_uri
		self.driver = driver
		self.user = user
		self.password = password
		self.table = table
		self.graph = Graph()
		
	def get_graph(self, map_value):
		self.graph.add((map_value, rml.logicalSource, ex.source))
		self.graph.add((ex.source, rdf.type, rml.LogicalSource))
		self.graph.add((ex.source, rr.tableName, Literal(self.table, datatype=XSD.string)))
		self.graph.add((ex.source, rml.source, ex.DB_source))
		self.graph.add((ex.source, rr.sqlVersion, rr.SQL2008)) # ?
		self.graph.add((ex.DB_source, rdf.type, d2rq.Database))
		self.graph.add((ex.DB_source, d2rq.jdbcDSN, Literal(self.connection_uri, datatype=XSD.string)))
		self.graph.add((ex.DB_source, d2rq.username, Literal(self.user, datatype=XSD.string)))
		self.graph.add((ex.DB_source, d2rq.password, Literal(self.password, datatype=XSD.string)))

		return self.graph

class TriplesMap:
	def __init__(self, name, source):
		self.name = name
		self.source = source
		self.graph = Graph()
		
	def import_mapp(self, mapping_file):
		self.graph.bind("rdf", rdf)
		self.graph.parse(mapping_file, format="turtle")
	
	def uniquize(self):
		
		rainbow = {}

		for subj, pred, obj in self.graph:
				
			if re.match("^http://mapping.example.com/.*", subj) and not re.match("^http://mapping.example.com/map_.*", subj):
				if not (subj in rainbow):
						
					rainbow[subj] = URIRef("http://mapping.example.com/uuid/"+str(uuid.uuid4()))

				self.graph.remove((subj,pred,obj))
				self.graph.add((rainbow[subj], pred, obj))

		for subj, pred, obj in self.graph:
			
			if re.match("^http://mapping.example.com/map.*", obj):
				
				pass
			
			elif re.match("^http://mapping.example.com/.*", obj):
				if not (obj in rainbow):
						
					rainbow[obj] = URIRef("http://mapping.example.com/uuid/"+str(uuid.uuid4()))

				self.graph.remove((subj,pred,obj))
				self.graph.add((subj, pred, rainbow[obj]))
				
	
	def link_source_graph(self):
		
		map_root = self.graph.value(subject=None, predicate = URIRef("http://www.w3.org/1999/02/22-rdf-syntax-ns#type"), object = URIRef("http://www.w3.org/ns/r2rml#TriplesMap"), any=True)

		if map_root is None:
			
			print("Ops!")

		else:

			self.graph += self.source.get_graph(map_root)
		
	
	def get_graph(self):
		
		self.link_source_graph()
		self.uniquize()
			
		return self.graph

class Mapping:
	
	def __init__(self):
		
		self.graph = Graph()
		
	def process_config(self, config):
		
		self.triplesmaps = []

		for e in config["entities"]:
			
			s = Source()
			
			if e["source"]["type"] == "mysql":
				s = MySQLSource(e["source"]["connection"]["dsn"], e["source"]["connection"]["driver"], e["source"]["connection"]["user"], e["source"]["connection"]["pass"], e["source"]["table"])
			elif e["source"]["type"] == "xml":
				s = MongoSource(e["source"]["connection"]["dsn"], e["source"]["connection"]["user"], e["source"]["connection"]["pass"], e["source"]["table"])
			elif e["source"]["type"] == "csv":
				s = CSVSource(e["source"]["file"])
			elif e["source"]["type"] == "json":
				s = JSONSource(e["source"]["file"])
			elif e["source"]["type"] == "xml":
				s = XMLSource(e["source"]["file"])
			
			else:
				print("Origen de datos " + str(e["source"]["type"]) + " no soportado!")
			
			ent = TriplesMap(e["name"], s)
			
			if "map" in e:
				ent.import_mapp(e["map"])
			
			self.triplesmaps.append(ent)
			
			print("Processing TripleMap: " + e["name"])

	def generate_graph(self):
		
		for ent in self.triplesmaps:
			
			self.graph += ent.get_graph()
	
				
	def get_mapping(self):
		
		
				
		return self.graph

parser = argparse.ArgumentParser(description='Generate multisource mapping file')
parser.add_argument('-c', '--config', dest='config', required=True, help="Data source configuration file")
parser.add_argument('-o', '--output', dest='out_mapping', required=True, help="Output mapping file")
parser.add_argument('-f', '--output-format', dest='out_format', required=False, default='turtle', help="Output mapping format. Format support can be extended with plugins, but “xml”, “n3”, “turtle”, “nt”, “pretty-xml”, “trix” and “trig” are built in.")

m = Mapping()

args = parser.parse_args()

config = json.load(open(args.config))

m.process_config(config)
m.generate_graph()

m.get_mapping().serialize(destination=args.out_mapping, format=str(args.out_format))

print("Mapping saved to: "+str(args.out_mapping))


