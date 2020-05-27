#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import subprocess
import json
from termcolor import colored
from PyInquirer import style_from_dict, Token, prompt
from PyInquirer import Validator, ValidationError

custom_style_3 = style_from_dict({
    Token.Separator: '#6C6C6C',
    Token.QuestionMark: '#FF9D00 bold',
    #Token.Selected: '',  # default
    Token.Selected: '#5F819D',
    Token.Pointer: '#FF9D00 bold',
    Token.Instruction: '',  # default
    Token.Answer: '#5F819D bold',
    Token.Question: '',
})

base_path = os.sep.join(os.path.realpath(__file__).split(os.sep)[:-2])

path_gen = base_path+"/generation/"
path_mapp = base_path+"/mappings/generator/"
tmp_path = base_path+"/tmp/"

tm_to_entity = {
	'AGENCY': 'AGENCY',
	'SERVICES2': 'CALENDAR_DATES',
	'CALENDAR_DATE_RULES': 'CALENDAR_DATES',
	'SERVICES1': 'CALENDAR',
	'CALENDAR_RULES': 'CALENDAR',
	'FEED': 'FEED_INFO',
	'FREQUENCIES': 'FREQUENCIES',
	'ROUTES': 'ROUTES',
	'SHAPES': 'SHAPES',
	'STOPS': 'STOPS',
	'STOPTIMES': 'STOP_TIMES',
	'TRIPS': 'TRIPS'
}

csv = { 'AGENCY': 'csv',
		'CALENDAR': 'csv',
		'CALENDAR_DATES': 'csv',
		'FEED_INFO': 'csv',
		'FREQUENCIES': 'csv',
		'ROUTES': 'csv',
		'SHAPES': 'csv',
		'STOPS': 'csv',
		'STOP_TIMES': 'csv',
		'TRIPS': 'csv'
	}
	
sql = { 'AGENCY': 'csv',
		'CALENDAR': 'csv',
		'CALENDAR_DATES': 'csv',
		'FEED_INFO': 'csv',
		'FREQUENCIES': 'csv',
		'ROUTES': 'csv',
		'SHAPES': 'csv',
		'STOPS': 'csv',
		'STOP_TIMES': 'csv',
		'TRIPS': 'csv'
	}
	
_json = { 'AGENCY': 'json',
		'CALENDAR': 'json',
		'CALENDAR_DATES': 'json',
		'FEED_INFO': 'json',
		'FREQUENCIES': 'json',
		'ROUTES': 'json',
		'SHAPES': 'json',
		'STOPS': 'json',
		'STOP_TIMES': 'json',
		'TRIPS': 'json'
	}
	
mongo = { 'AGENCY': 'json',
		'CALENDAR': 'json',
		'CALENDAR_DATES': 'json',
		'FEED_INFO': 'json',
		'FREQUENCIES': 'json',
		'ROUTES': 'json',
		'SHAPES': 'json',
		'STOPS': 'json',
		'STOP_TIMES': 'json',
		'TRIPS': 'json'
	}

xml = { 'AGENCY': 'xml',
		'CALENDAR': 'xml',
		'CALENDAR_DATES': 'xml',
		'FEED_INFO': 'xml',
		'FREQUENCIES': 'xml',
		'ROUTES': 'xml',
		'SHAPES': 'xml',
		'STOPS': 'xml',
		'STOP_TIMES': 'xml',
		'TRIPS': 'xml'
	}
	
		
best = { 'AGENCY': 'json',
		'CALENDAR': 'csv',
		'CALENDAR_DATES': 'csv',
		'FEED_INFO': 'mongo',
		'FREQUENCIES': 'sql',
		'ROUTES': 'json',
		'SHAPES': 'csv',
		'STOPS': 'xml',
		'STOP_TIMES': 'xml',
		'TRIPS': 'csv'
	}

worst = { 'AGENCY': 'sql',
		'CALENDAR': 'sql',
		'CALENDAR_DATES': 'mongo',
		'FEED_INFO': 'json',
		'FREQUENCIES': 'mongo',
		'ROUTES': 'xml',
		'SHAPES': 'csv',
		'STOPS': 'csv',
		'STOP_TIMES': 'xml',
		'TRIPS': 'json'
	}
	
static_distributions = {'csv': csv,
						'json': _json,
						'xml': xml,
						'sql': sql,
						'mongo': mongo,
						'best': best,
						'worst': worst}


default_mysql = {

		"type": "mysql",
		"connection": {
			"user": "oeg",
			"pass": "oeg",
			"dsn": "jdbc:mysql://localhost:3306/gtfs",
			"driver": "com.mysql.cj.jdbc.Driver"
		}
	}

default_mongo = {

		"type": "mongo",
		"connection": {
			"user": "oeg",
			"pass": "oeg",
			"dsn": "jdbc:mongo://localhost:27017",
		}
	}

def generate_dataset(size):
		
	os.chdir(path_gen)
	
	print("Running VIG with scale", size)
	
	os.system("java -jar bin/vig-1.8.1.jar --res=resources --scale="+str(size)+" > /dev/null")
	
	os.chdir(path_gen+'/resources/csvs/')
	
	os.system("./clean.sh > /dev/null")
	
	os.system("./headers.sh > /dev/null")
	
	
def generate_distribution(distribution):	
		
	try:
		os.mkdir('./dist/'+distribution)
	except:
		pass	
		
	print("\tPreparing distribution:", distribution)
	
	for tm in static_distributions[distribution]:
				
		f = static_distributions[distribution][tm]
		
		if f == 'csv' or f == 'sql':
			os.system("cp "+tm+".csv ./dist/"+distribution+"/"+tm+".csv")
		elif f == 'json' or f == 'mongo':
			os.system("csvjson --stream --no-inference "+tm+".csv > ./dist/"+distribution+"/"+tm+".json")
		elif f == 'xml':
			os.system("./di-csv2xml Category -i "+tm+".csv -o ./dist/"+distribution+"/"+tm+".xml")
	
	# Need TM <--> Format relation
	
def generate_mapping(distribution):
	
	
			 
	tms = []
	
	for tm in tm_to_entity:
		
		e = tm_to_entity[tm]
		
		f = static_distributions[distribution][e]
		
		t = {
			'name': tm,
			'map': 'partial/'+tm.lower()+'.ttl'
		}
		
		print("\tGenerating mapping:", f)
		
		if f == 'csv':
			t['source'] = {'type': 'csv', 'file': e+'.csv'}
		elif f == 'json':
			t['source'] = {'type': 'json', 'file': e+'.json'}
		elif f == 'xml':
			t['source'] = {'type': 'xml', 'file': e+'.xml'}	
		elif f == 'mongo':
			t['source'] = default_mongo
			t['source']['table'] = 'gtfs.'+e
		elif f == 'sql':
			t['source'] = default_mysql
			t['source']['table'] = 'gtfs.'+e
		else:
			print("Format", f, "not implemented")
			
		tms.append(t)
		
	
	config = {
				"entities": tms
			}
			
	os.chdir(path_mapp)
			 
	with open("config_"+distribution+".json", 'w') as outfile:
		json.dump(config, outfile)

	os.system("python3 app.py -c config_"+distribution+".json -o /tmp/output/mappings/mapping_"+distribution+".nt -f nt > /dev/null")


try:
	os.mkdir(tmp_path)
except:
	pass


print(colored('''
   mmm mmmmmmm mmmmmm  mmmm         mmmmm  mmmmmm mm   m   mmm  m    m
 m"   "   #    #      #"   "        #    # #      #"m  # m"   " #    #
 #   mm   #    #mmmmm "#mmm         #mmmm" #mmmmm # #m # #      #mmmm#
 #    #   #    #          "#  """   #    # #      #  # # #      #    #
  "mmm"   #    #      "mmm#"        #mmmm" #mmmmm #   ##  "mmm" #    #

This script will guide in the generation of benchmarking datasets and mappings
based on the GTFS transport data format.

''', 'red'))

print('Datasets can be scaled as desired, by default we use 1, 5, 10, 50, 100, 500, 1000 and 5000 sizes but you can specify your own selection and we\'ll generate it...\n')

q1 = [
    {
        'type': 'list',
        'name': 'q',
        'message': 'So... what do you want?',
        'choices': [
			{'name':'Use pregenerated default sizes', 'value': 'default'},
			{'name':'Specify my own size(s)', 'value': 'custom'}
		],
    }
]

q2 = [
    {
        'type': 'input',
        'name': 'q',
        'message': '\nPlease, specify the size(s) separated by commas',
    }
]

q3 = [
    {
        'type': 'checkbox',
        'name': 'q',
        'message': '\nNow let\'s select the output formats! This will also generate the corresponding mapping files. Choose which ones you want:',
        'choices': [ 
            {
                'name': 'JSON',
                'value': 'json'
            },
            {
                'name': 'SQL',
                'value': 'sql'
            },
            {
                'name': 'XML',
				'value': 'xml'
            },
            {
                'name': 'CSV',
				'value': 'csv'
            },
            {
                'name': 'Best',
                'value': 'best',
                'checked': True
            },
            {
                'name': 'Worst',
                'value': 'worst',
                'checked': True
            }
            #,
            #{
            #    'name': 'Customized'
            #}'''
            
        ]
    }
]

q1_a = prompt(q1)

if q1_a["q"] == 'custom':
	sizes = [int(x) for x in map(int, prompt(q2, style=custom_style_3)["q"].split(","))]

else:

	sizes = [1,5,10,50,100,500,1000,5000]
	
q3_a = prompt(q3)

distribution = q3_a["q"]

#Data

for s in sizes:
	
	print("Generating dataset at scale: "+str(s))
	
	#debug = subprocess.run(["./generate.sh", str(s)], capture_output=True)
	
	os.system(path_gen+"./generate.sh "+str(s)+" "+path_gen)
	
	os.chdir(path_gen+'/resources/csvs/')
	
	#os.system("rm -r ./dist/ > /dev/null")
	os.system("mkdir ./dist/")
	
	for d in distribution:
	
		generate_distribution(d)
		
	os.system("rm *.csv")
	os.system("mv ./dist/ /tmp/output/datasets/"+str(s)+"/")

#Mapping

for d in distribution:
	
	generate_mapping(d)
	
print("DONE!")
	
