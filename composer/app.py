#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import subprocess
import json
import signal
import sys
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

csv_distribution = {'name': 'csv',
		'formats': { 'AGENCY': 'csv',
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
		}

sql_distribution = {'name': 'sql',
		'formats': { 'AGENCY': 'sql',
				'CALENDAR': 'sql',
				'CALENDAR_DATES': 'sql',
				'FEED_INFO': 'sql',
				'FREQUENCIES': 'sql',
				'ROUTES': 'sql',
				'SHAPES': 'sql',
				'STOPS': 'sql',
				'STOP_TIMES': 'sql',
				'TRIPS': 'sql'
			}
		}

json_distribution = {'name': 'json',
		'formats': { 'AGENCY': 'json',
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
		}

mongo_distribution = {'name': 'mongo',
		'formats': { 'AGENCY': 'mongo',
				'CALENDAR': 'mongo',
				'CALENDAR_DATES': 'mongo',
				'FEED_INFO': 'mongo',
				'FREQUENCIES': 'mongo',
				'ROUTES': 'mongo',
				'SHAPES': 'mongo',
				'STOPS': 'mongo',
				'STOP_TIMES': 'mongo',
				'TRIPS': 'mongo'
			}
		}

xml_distribution = {'name': 'xml',
		'formats': { 'AGENCY': 'xml',
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
		}

static_distributions = {
	'csv': csv_distribution,
	'json': json_distribution,
	'xml': xml_distribution,
	'sql': sql_distribution,
	'mongo': mongo_distribution
	}


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

def has_mysql(distribution):

	has = False

	for tm in distribution['formats']:

		if distribution['formats'][tm] == 'sql':

			has = True

			break

	return has

def has_mongodb(distribution):

	has = False

	for tm in distribution['formats']:

		if distribution['formats'][tm] == 'mongo':

			has = True

			break

	return has

def generate_sql_schema(distribution, size=1, absolute_path='/tmp/output/'):

	if has_mysql(distribution):

		schema = '''
			DROP DATABASE IF EXISTS `gtfs-{0}`;
			SET GLOBAL local_infile = 1;
			CREATE DATABASE IF NOT EXISTS `gtfs-{0}`;
			USE `gtfs-{0}`;'''

		schema_post = ""

		if distribution['formats']['AGENCY'] == 'sql':

			schema += '''
				DROP TABLE IF EXISTS AGENCY;

				CREATE TABLE AGENCY (`agency_id` VARCHAR(200),
				`agency_name` VARCHAR(200),
				`agency_url` VARCHAR(200),
				`agency_timezone` VARCHAR(200),
				`agency_lang` VARCHAR(200),
				`agency_phone` VARCHAR(200) DEFAULT NULL,
				`agency_fare_url` VARCHAR(200) DEFAULT NULL,
				PRIMARY KEY (agency_id));

				LOAD DATA LOCAL INFILE '{2}datasets/{0}/{1}/AGENCY.csv'
				INTO TABLE AGENCY FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
					SET agency_phone = IF(agency_phone = '', NULL, agency_phone),
					agency_fare_url = IF(agency_fare_url = '', NULL, agency_fare_url);

				'''

		if distribution['formats']['CALENDAR_DATES'] == 'sql':

			schema += '''

				DROP TABLE IF EXISTS CALENDAR_DATES;
				CREATE TABLE CALENDAR_DATES (`service_id` VARCHAR(200),
				`date` DATE,
				`exception_type` INT,
				PRIMARY KEY (service_id,date));

				LOAD DATA LOCAL INFILE '{2}datasets/{0}/{1}/CALENDAR_DATES.csv'
				INTO TABLE CALENDAR_DATES FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
					SET exception_type = IF(exception_type=2,0,exception_type);

			'''


		if distribution['formats']['CALENDAR'] == 'sql':

			schema += '''

				DROP TABLE IF EXISTS CALENDAR;
				CREATE TABLE CALENDAR (`service_id` VARCHAR(200),
				`monday` INT,
				`tuesday` INT,
				`wednesday` INT,
				`thursday` INT,
				`friday` INT,
				`saturday` INT,
				`sunday` INT,
				`start_date` DATE,
				`end_date` DATE DEFAULT NULL,
				PRIMARY KEY (service_id));

				LOAD DATA LOCAL INFILE '{2}datasets/{0}/{1}/CALENDAR.csv'
				INTO TABLE CALENDAR FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
					SET end_date = IF(end_date = '', NULL, end_date);

			'''

		if distribution['formats']['FEED_INFO'] == 'sql':

			schema += '''

				DROP TABLE IF EXISTS FEED_INFO;
				CREATE TABLE FEED_INFO (`feed_publisher_name` VARCHAR(200),
				`feed_publisher_url` VARCHAR(200),
				`feed_lang` VARCHAR(200),
				`feed_start_date` DATE DEFAULT NULL,
				`feed_end_date` DATE DEFAULT NULL,
				`feed_version` VARCHAR(200),
				PRIMARY KEY (feed_publisher_name));

				LOAD DATA LOCAL INFILE '{2}datasets/{0}/{1}/FEED_INFO.csv'
				INTO TABLE FEED_INFO FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
				   SET feed_start_date = IF(feed_start_date = '', NULL, feed_start_date),
				   feed_end_date = IF(feed_end_date = '', NULL, feed_end_date);

				UPDATE FEED_INFO set feed_start_date = NULL where feed_start_date=0000-00-00;
				UPDATE FEED_INFO set feed_end_date = NULL where feed_end_date=0000-00-00;

			'''


		if distribution['formats']['FREQUENCIES'] == 'sql':

			schema += '''

				DROP TABLE IF EXISTS FREQUENCIES;
				CREATE TABLE FREQUENCIES (`trip_id` VARCHAR(200),
				`start_time` VARCHAR(200),
				`end_time` VARCHAR(200),
				`headway_secs` INT,
				`exact_times` INT DEFAULT 0,
				PRIMARY KEY (trip_id,start_time));

				LOAD DATA LOCAL INFILE '{2}datasets/{0}/{1}/FREQUENCIES.csv'
				INTO TABLE FREQUENCIES FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
					SET exact_times = IF(exact_times='',NULL,exact_times);

			'''

			if distribution['formats']['TRIPS'] == 'sql':

				schema_post += '''

					ALTER TABLE  FREQUENCIES  ADD FOREIGN  KEY (trip_id) REFERENCES TRIPS (trip_id);

				'''


		if distribution['formats']['ROUTES'] == 'sql':

			schema += '''
				DROP TABLE IF EXISTS ROUTES;
				CREATE TABLE ROUTES (`route_id` VARCHAR(200),
				`agency_id` VARCHAR(200),
				`route_short_name` VARCHAR(200),
				`route_long_name` VARCHAR(200),
				`route_desc` VARCHAR(200) DEFAULT NULL,
				`route_type` INT,
				`route_url` VARCHAR(200),
				`route_color` VARCHAR(200),
				`route_text_color` VARCHAR(200),
				PRIMARY KEY (route_id));

				LOAD DATA LOCAL INFILE '{2}datasets/{0}/{1}/ROUTES.csv'
				INTO TABLE ROUTES FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
					SET route_desc = IF(route_desc = '', NULL, route_desc);

			'''

			if distribution['formats']['AGENCY'] == 'sql':

				schema_post += '''

					ALTER TABLE  ROUTES  ADD FOREIGN  KEY (agency_id) REFERENCES AGENCY (agency_id);

				'''

		if distribution['formats']['SHAPES'] == 'sql':

			schema += '''

				DROP TABLE IF EXISTS SHAPES;
				CREATE TABLE SHAPES (`shape_id` VARCHAR(200),
				`shape_pt_lat` DECIMAL(18,15),
				`shape_pt_lon` DECIMAL(18,15),
				`shape_pt_sequence` INT,
				`shape_dist` DECIMAL(18,15),
				PRIMARY KEY (shape_id,shape_pt_sequence));

				LOAD DATA LOCAL INFILE '{2}datasets/{0}/{1}/SHAPES.csv'
				INTO TABLE SHAPES FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;


			'''

		if distribution['formats']['STOPS'] == 'sql':

			schema += '''

				DROP TABLE IF EXISTS STOPS;
				CREATE TABLE STOPS (`stop_id` VARCHAR(200),
				`stop_code` VARCHAR(200),
				`stop_name` VARCHAR(200),
				`stop_desc` VARCHAR(200),
				`stop_lat` DECIMAL(18,15),
				`stop_lon` DECIMAL(18,15),
				`zone_id` VARCHAR(200),
				`stop_url` VARCHAR(200),
				`location_type` INT,
				`parent_station` VARCHAR(200),
				`stop_timezone` VARCHAR(200) DEFAULT NULL,
				`wheelchair_boarding` INT,
				PRIMARY KEY (stop_id));

				LOAD DATA LOCAL INFILE '{2}datasets/{0}/{1}/STOPS.csv'
				INTO TABLE STOPS FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
				   SET zone_id = IF(zone_id = '', NULL, zone_id),
				   stop_timezone = IF(stop_timezone = '', NULL, stop_timezone),
				   parent_station = IF(parent_station = '', NULL, parent_station);

				ALTER TABLE  STOPS ADD FOREIGN KEY (parent_station) REFERENCES STOPS (stop_id);


			'''

		if distribution['formats']['STOP_TIMES'] == 'sql':

			schema += '''

				DROP TABLE IF EXISTS STOP_TIMES;
				CREATE TABLE STOP_TIMES (`trip_id` VARCHAR(200),
				`arrival_time` VARCHAR(200),
				`departure_time` VARCHAR(200),
				`stop_id` VARCHAR(200),
				`stop_sequence` INT,
				`stop_headsign` VARCHAR(200),
				`pickup_type` INT DEFAULT 0,
				`drop_off_type` INT DEFAULT 0,
				`shape_dist_traveled` DECIMAL(18,15),
				PRIMARY KEY (trip_id,stop_id,arrival_time));

				LOAD DATA LOCAL INFILE '{2}datasets/{0}/{1}/STOP_TIMES.csv' INTO TABLE STOP_TIMES FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
				   SET trip_id = IF(trip_id = '', NULL, trip_id),
					   arrival_time = IF(arrival_time = '', NULL, arrival_time),
					   departure_time = IF(departure_time = '', NULL, departure_time),
					   stop_id = IF(stop_id = '', NULL, stop_id),
					   stop_sequence = IF(stop_sequence = '', NULL, stop_sequence),
					   stop_headsign = IF(stop_headsign = '', NULL, stop_headsign),
					   shape_dist_traveled = IF(shape_dist_traveled = '', NULL, shape_dist_traveled);
			'''

			if distribution['formats']['STOPS'] == 'sql':

				schema_post += '''

					ALTER TABLE  STOP_TIMES  ADD FOREIGN  KEY (stop_id) REFERENCES STOPS (stop_id);

				'''

			if distribution['formats']['TRIPS'] == 'sql':

				schema_post += '''

					ALTER TABLE  STOP_TIMES  ADD FOREIGN  KEY (trip_id) REFERENCES TRIPS (trip_id);

				'''

		if distribution['formats']['TRIPS'] == 'sql':

			schema += '''

				DROP TABLE IF EXISTS TRIPS;
				CREATE TABLE TRIPS (`route_id` VARCHAR(200),
				`service_id` VARCHAR(200),
				`trip_id` VARCHAR(200),
				`trip_headsign` VARCHAR(200),
				`trip_short_name` VARCHAR(200),
				`direction_id` INT,
				`block_id` VARCHAR(200) DEFAULT NULL,
				`shape_id` VARCHAR(200),
				`wheelchair_accessible` INT,
				PRIMARY KEY (trip_id));

				LOAD DATA LOCAL INFILE '{2}datasets/{0}/{1}/TRIPS.csv'
				INTO TABLE TRIPS FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
					SET block_id = IF(block_id = '', NULL, block_id);


			'''

			if distribution['formats']['SHAPES'] == 'sql':

				schema_post += '''

					ALTER TABLE  TRIPS  ADD FOREIGN  KEY (shape_id) REFERENCES SHAPES (shape_id);

				'''

			if distribution['formats']['ROUTES'] == 'sql':

				schema_post += '''

					ALTER TABLE  TRIPS  ADD FOREIGN  KEY (route_id) REFERENCES ROUTES (route_id);

				'''

			if distribution['formats']['CALENDAR'] == 'sql':

				schema_post += '''

					ALTER TABLE  TRIPS  ADD FOREIGN  KEY (service_id) REFERENCES CALENDAR (service_id);

				'''

			if distribution['formats']['CALENDAR_DATES'] == 'sql':

				schema_post += '''

					ALTER TABLE  TRIPS  ADD FOREIGN KEY (service_id) REFERENCES CALENDAR_DATES (service_id);

				'''

		schema += schema_post

		data = schema.format(size, distribution['name'], absolute_path)

		with open('/tmp/output/schema-{0}.sql'.format(size), 'w') as f:

			f.write(data)


	else:

		print("Unable to generate MySQL schema, no TM uses MySQL as data source")

		return None


def generate_distribution(distribution):

	#print(distribution)

	try:
		os.mkdir('./dist/'+distribution['name'])
	except:
		pass

	print("\tPreparing distribution:", distribution['name'])

	for tm in distribution['formats']:

		f = distribution['formats'][tm]

		if f == 'csv' or f == 'sql': # We import CSV files to MySQL instance
			os.system("cp "+tm+".csv ./dist/"+distribution['name']+"/"+tm+".csv")
		elif f == 'json' or f == 'mongo': # Mongo format is JSON
			os.system("csvjson --stream --no-inference "+tm+".csv > ./dist/"+distribution['name']+"/"+tm+".json")
		elif f == 'xml':
			os.system("./di-csv2xml Category -i "+tm+".csv -o ./dist/"+distribution['name']+"/"+tm+".xml")

def custom_distribution():

	tm_list = list(dict.fromkeys(list(tm_to_entity.values())).keys())

	options = [{
                'name': 'JSON',
                'value': 'json'
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
                'name': 'MongoDB',
                'value': 'mongo',
            },
            {
                'name': 'MySQL',
                'value': 'mysql',
            }]

	formats = dict()

	q = [
			{
				'type': 'list',
				'name': 'q',
				'message': '',
				'choices': [
					{
						'name': 'JSON',
						'value': 'json',
						'checked': True
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
						'name': 'MongoDB',
						'value': 'mongo',
					},
					{
						'name': 'MySQL',
						'value': 'sql',
					}

				]
			}
		]

	for tm in tm_list:

		q[0]['message'] = '[ Custom distribution ] Select output format for {} TM:'.format(tm)

		q_a = prompt(q)['q']

		formats[tm] = q_a

	distrib = {'name': 'custom',
		'formats': formats}

	return distrib

def deploy_mysql(size):

	os.system('pv -f "/tmp/output/schema-{0}.sql" | mysql -uoeg -poeg '.format(size))

def deploy(distributions, size):

	dist_options = list()

	for d in distributions:
		dist_options.append({
			'name': d['name'],
			'value': d['name']
		})

	q6 = [
		{
			'type': 'list',
			'name': 'q',
			'message': 'Select the distribution to deploy:',
			'choices': dist_options
		}
	]

	q6_a = prompt(q6)['q']

	distribution = None

	for d in distributions:

		if d['name'] == q6_a:

			distribution = d

	print("Importing data in MySQL server")

	for s in sizes:

		generate_sql_schema(distribution, s)

		deploy_mysql(s)

	#deploy_mongodb()

	print("Services ready! Remember to export the 3306 and 27017 ports outside this Docker container.")

def generate_mapping(distribution):

	tms = []

	for tm in tm_to_entity:

		e = tm_to_entity[tm]

		f = distribution['formats'][e]

		t = {
			'name': tm,
			'map': 'partial/'+tm.lower()+'.ttl'
		}

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

	with open("config_"+distribution['name']+".json", 'w') as outfile:
		json.dump(config, outfile)

	os.system("python3 app.py -c config_"+distribution['name']+".json -o /tmp/output/mappings/mapping_"+distribution['name']+".nt -f nt > /dev/null")


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
        'message': 'Please, specify the size(s) separated by commas',
    }
]

q3 = [
    {
        'type': 'checkbox',
        'name': 'q',
        'message': 'Now let\'s select the output formats! This will also generate the corresponding mapping files. Choose which ones you want:',
        'choices': [
            {
                'name': 'JSON',
                'value': 'json'
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
                'name': 'MongoDB',
                'value': 'mongo',
            },
            {
                'name': 'MySQL',
                'value': 'sql',
            },
            {
                'name': 'Custom distribution',
                'value': 'custom'

            }

        ],
        'validate': lambda answer: 'You must choose at least one distribution!.' \
            if len(answer) == 0 else True
    }
]

q1_a = prompt(q1)

if q1_a["q"] == 'custom':
	sizes = [int(x) for x in map(int, prompt(q2, style=custom_style_3)["q"].split(","))]

else:

	sizes = [1,5,10,50,100,500,1000,5000]

q3_a = prompt(q3)["q"]

distributions = list()

for a in q3_a:
	if a == 'custom':
		distributions.append(custom_distribution())
	else:
		distributions.append(static_distributions[a])

#Base RDF

q4 = [
    {
        'type': 'list',
        'name': 'q',
        'message': 'Do you want to generate base RDF (scale 1) using SDM-RDFizer?',
        'choices': [
			{'name':'Yes', 'value': 'yes'},
			{'name':'No', 'value': 'no'}
		],
    }
]

q4_a = prompt(q4)['q']

if q4_a == 'yes':

	print("Generating base RDF using SDM-RDFizer...")

	os.system(path_gen+"./generate.sh 1 "+path_gen)

	os.mkdir("/tmp/output/rdf/")

	generate_mapping(csv_distribution)

	os.chdir(path_gen+'/resources/csvs/')

	os.system("python3.5 /repository/SDM-RDFizer/rdfizer/run_rdfizer.py /repository/gtfs-bench/semantify/csv.conf")

	os.system("rm *.csv")

#Data

for s in sizes:

	print("Generating dataset at scale: "+str(s))

	#debug = subprocess.run(["./generate.sh", str(s)], capture_output=True)

	os.system(path_gen+"./generate.sh "+str(s)+" "+path_gen)

	os.chdir(path_gen+'/resources/csvs/')

	#os.system("rm -r ./dist/ > /dev/null")
	os.system("mkdir ./dist/")

	for d in distributions:

		generate_distribution(d)

	os.system("rm *.csv")
	os.system("mv ./dist/ /tmp/output/datasets/"+str(s)+"/")

# Cleanup

os.system("echo 'DROP DATABASE `gtfs`' | mysql -u root")



#Mapping

for d in distributions:

	generate_mapping(d)


#Move

os.system("cp /repository/gtfs-bench/queries/vig/*.rq /tmp/output/queries/")
os.chdir("/tmp/output/")
os.system("zip  -9 -r /output/result.zip . > /dev/null")

#Deploy

q5 = [
    {
        'type': 'list',
        'name': 'q',
        'message': 'Do you want to start a MySQL and MongoDB server with the generated data?',
        'choices': [
			{'name':'Yes', 'value': 'yes'},
			{'name':'No', 'value': 'no'}
		],
    }
]

q5_a = prompt(q5)['q']

if q5_a == 'yes':
	deploy(distributions, sizes)

print("Remember, the generated data is in the result.zip file at the current path.")

def signal_handler(sig, frame):
    print('\nBye! ')
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)
print('Press Ctrl+C to exit')
signal.pause()

