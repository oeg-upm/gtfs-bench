import argparse
import re
import uuid
import json
from rdflib import Graph, URIRef
from enum import Enum

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
		self.graph.add((map_value, URIRef("http://semweb.mmlab.be/ns/rml#logicalSource"), URIRef("http://mapping.example.com/source_0")))
		self.graph.add((URIRef("http://mapping.example.com/source_0"), URIRef("http://www.w3.org/1999/02/22-rdf-syntax-ns#type"), URIRef("http://semweb.mmlab.be/ns/rml#LogicalSource")))
		self.graph.add((URIRef("http://mapping.example.com/source_0"), URIRef("http://semweb.mmlab.be/ns/rml#source"), URIRef(self.filename)))
		self.graph.add((URIRef("http://mapping.example.com/source_0"), URIRef("http://semweb.mmlab.be/ns/rml#referenceFormulation"), URIRef("http://semweb.mmlab.be/ns/ql#CSV")))
		
		return self.graph
		
class JSONSource(Source):
	def __init__(self, filename):
		self.filename = filename
		
class MySQLSource(Source):
	def __init__(self, connection_uri, driver, user, password, table):
		self.connection_uri = connection_uri
		self.driver = driver
		self.user = user
		self.password = password
		self.table = table
		self.graph = Graph()
		
	'''
	map:source_9 a rml:LogicalSource;
    rr:tableName "gtfs.FEED_INFO";
    rml:source <#DB_source> ;
    rr:sqlVersion rr:SQL2008 .

	<#DB_source> a d2rq:Database;
		d2rq:jdbcDSN "jdbc:mysql://localhost:3306/gtfs";
		d2rq:jdbcDriver "com.mysql.cj.jdbc.Driver";
		d2rq:username "root";
		d2rq:password "oeg".
	'''	
	
	def get_graph(self):
		return self.graph
		#graph.add("http://mapping.example.com/source")

class Entity:
	def __init__(self, name, source):
		self.name = name
		self.source = source
		self.graph = Graph()
		
	def import_mapp(self, mapping_file):
		self.graph.parse(mapping_file, format="turtle")
	
	def uniquize(self):
		
		rainbow = {}

		for subj, pred, obj in self.graph:
				
			if re.match("^http://mapping.example.com/.*", subj):
				if not (subj in rainbow):
						
					rainbow[subj] = URIRef("http://mapping.example.com/uuid/"+str(uuid.uuid4()))

				self.graph.remove((subj,pred,obj))
				self.graph.add((rainbow[subj], pred, obj))

		for subj, pred, obj in self.graph:
			
			if re.match("^http://mapping.example.com/.*", obj):
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

g = Graph()
result = g.parse("partial/trips.ttl", format="turtle")

print(result)

parser = argparse.ArgumentParser(description='Generate multisource mapping file')
parser.add_argument('--config-file', dest='in_config', required=True)
#parser.add_argument('--input-mapping', dest='in_mapping', required=True)
#parser.add_argument('--output-mapping', dest='out_mapping', required=True)

args = parser.parse_args()

config = json.load(open(args.in_config))

entities = []

for e in config["entities"]:
	
	s = Source()
	
	if e["source"]["type"] == "mysql":
		s = MySQLSource(e["source"]["connection"]["dsn"], e["source"]["connection"]["driver"], e["source"]["connection"]["user"], e["source"]["connection"]["pass"], e["source"]["table"])
	elif e["source"]["type"] == "csv":
		s = CSVSource(e["source"]["file"])
	elif e["source"]["type"] == "json":
		pass
	else:
		print("Origen de datos " + str(e["source"]["type"]) + " no soportado!")
	
	ent = Entity(e["name"], s)
	
	if "map" in e:
		ent.import_mapp(e["map"])
	
	entities.append(ent)
	
	print(e["name"])

mapping = Graph()

for ent in entities:
	
	mapping += ent.get_graph()

dump_graph(mapping)
