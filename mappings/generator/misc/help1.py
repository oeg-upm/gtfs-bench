#!/usr/bin/env python3

from rdflib import Graph, URIRef, Namespace, Literal

g = Graph()
g.parse("test01.ttl", format="turtle")

for s in g.subjects(predicate = URIRef("http://www.w3.org/1999/02/22-rdf-syntax-ns#type"), object = URIRef("http://semweb.mmlab.be/ns/rml#LogicalSource")):

	source = g.value(predicate = URIRef("http://www.w3.org/ns/r2rml#tableName"), subject=s, any=True)

	if source is None:
		
		source = g.value(predicate = URIRef("http://semweb.mmlab.be/ns/rml#source"), subject=s, any=True)


	tm = g.value(predicate = URIRef("http://semweb.mmlab.be/ns/rml#logicalSource"), object=s, any=True)
	
	label = g.value(predicate = URIRef("http://www.w3.org/2000/01/rdf-schema#label"), subject=tm, any=True)

	print(tm,"\n\t["+str(source)+"]", " --- genera ----> ", label, "\n")
