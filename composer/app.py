#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import csv
import json
import signal
import sys
import copy
import random
import shutil
from termcolor import colored
from PyInquirer import style_from_dict, Token, prompt

custom_style_3 = style_from_dict({
    Token.Separator: '#6C6C6C',
    Token.QuestionMark: '#FF9D00 bold',
    Token.Selected: '#5F819D',
    Token.Pointer: '#FF9D00 bold',
    Token.Instruction: '',  # default
    Token.Answer: '#5F819D bold',
    Token.Question: '',
})

base_path = os.sep.join(os.path.realpath(__file__).split(os.sep)[:-2])
path_gen = os.path.join(base_path, 'generation/')
path_mapp = os.path.join(base_path, 'mappings/generator/')

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
    'SHAPE_POINTS': 'SHAPES',
    'STOPS': 'STOPS',
    'STOPTIMES': 'STOP_TIMES',
    'TRIPS': 'TRIPS'
}

csv_distribution = {
    'name': 'csv',
    'formats': {
        'AGENCY': 'csv',
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

sql_distribution = {
    'name': 'sql',
    'formats': {
        'AGENCY': 'sql',
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

json_distribution = {
    'name': 'json',
    'formats': {
        'AGENCY': 'json',
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

mongo_distribution = {
    'name': 'mongo',
    'formats': {
        'AGENCY': 'mongo',
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

xml_distribution = {
    'name': 'xml',
    'formats': {
        'AGENCY': 'xml',
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
    'type': 'mysql',
    'connection': {
        'user': 'oeg',
        'pass': 'oeg',
        'dsn': 'jdbc:mysql://localhost:3306/gtfs',
        'driver': 'com.mysql.cj.jdbc.Driver'
    }
}

default_mongo = {
    'type': 'mongo',
    'connection': {
        'user': 'oeg',
        'pass': 'oeg',
        'dsn': 'jdbc:mongo://localhost:27017',
    }
}


def create_file_structure(sizes, distributions):
    for d in distributions:
        os.makedirs(os.path.join('/tmp/output/datasets/', d['name']),
                    exist_ok=True)
        for s in sizes:
            os.makedirs(os.path.join('/tmp/output/datasets/', d['name'],
                                     str(s)), exist_ok=True)


def has_mysql(distribution):
    for tm in distribution['formats']:
        if distribution['formats'][tm] == 'sql':
            return True


def generate_sql_schema(distribution, size):
    if has_mysql(distribution):
        schema = '''
            DROP DATABASE IF EXISTS `gtfs-{0}`;
            SET GLOBAL local_infile = 1;
            CREATE DATABASE IF NOT EXISTS `gtfs-{0}`;
            USE `gtfs-{0}`;'''

        schema_post = ''

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
                INTO TABLE AGENCY FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\\n' IGNORE 1 ROWS
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
                INTO TABLE CALENDAR_DATES FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\\n' IGNORE 1 ROWS
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
                INTO TABLE CALENDAR FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\\n' IGNORE 1 ROWS
                    SET end_date = IF(end_date = NULL, NULL, end_date);

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
                INTO TABLE FEED_INFO FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\\n' IGNORE 1 ROWS
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
                INTO TABLE FREQUENCIES FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\\n' IGNORE 1 ROWS;

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
                INTO TABLE ROUTES FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\\n' IGNORE 1 ROWS
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
                `shape_dist_traveled` DECIMAL(18,15),
                PRIMARY KEY (shape_id,shape_pt_sequence));

                LOAD DATA LOCAL INFILE '{2}datasets/{0}/{1}/SHAPES.csv'
                INTO TABLE SHAPES FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\\n' IGNORE 1 ROWS;


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
                INTO TABLE STOPS FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\\n' IGNORE 1 ROWS
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

                LOAD DATA LOCAL INFILE '{2}datasets/{0}/{1}/STOP_TIMES.csv' INTO TABLE STOP_TIMES FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\\n' IGNORE 1 ROWS

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
                INTO TABLE TRIPS FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\\n' IGNORE 1 ROWS
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
        data = schema.format(distribution['name'], size, './')
        p = os.path.join('/tmp/output/datasets/', distribution['name'],
                         size, '/mysql_schema.sql')
        with open(p, 'w') as f:
            f.write(data)
        return True

    return False


def generate_distribution(size, distribution):
    try:
        os.mkdir(os.path.join('./dist/', distribution['name']))
    except Exception:
        pass

    print(f'\tPreparing distribution: {distribution["name"]}')

    for tm in distribution['formats']:
        f = distribution['formats'][tm]
        if f == 'csv' or f == 'sql':  # We import CSV files to MySQL instance
            p = os.path.join('/tmp/output/datasets/', distribution['name'],
                             str(size), f'{tm}.csv')
            os.system(f'cp {tm}.csv {p}')
        elif f == 'json' or f == 'mongo':  # Mongo format is JSON
            p = os.path.join('/tmp/output/datasets/', distribution['name'],
                             str(size), f'{tm}.json')
            os.system(f'python3 -m csv2all -f json -i {tm}.csv -o {p}')
        elif f == 'xml':
            p = os.path.join('/tmp/output/datasets/', distribution['name'],
                             str(size), f'{tm}.xml')
            os.system(f'./di-csv2xml Category -i {tm}.csv -o {p} > /dev/null')


def custom_distribution():
    tm_list = list(dict.fromkeys(list(tm_to_entity.values())).keys())
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
        q[0]['message'] = '[ Custom distribution ] Select output format ' + \
            f'for {tm} data source:'
        q_a = prompt(q)['q']
        formats[tm] = q_a

    distrib = {'name': 'custom', 'formats': formats}
    return distrib


def generate_mapping(distribution):
    tms = []
    for tm in tm_to_entity:
        e = tm_to_entity[tm]
        f = distribution['formats'][e]
        t = {'name': tm, 'map': f'partial/{tm.lower()}.ttl'}

        if f == 'csv':
            t['source'] = {'type': 'csv', 'file': f'{e}.csv'}
        elif f == 'json':
            t['source'] = {'type': 'json', 'file': f'{e}.json'}
        elif f == 'xml':
            t['source'] = {'type': 'xml', 'file': f'{e}.xml'}
        elif f == 'mongo':
            t['source'] = copy.deepcopy(default_mongo)
            t['source']['table'] = f'gtfs.{e}'
        elif f == 'sql':
            t['source'] = copy.deepcopy(default_mysql)
            t['source']['table'] = f'gtfs.{e}'
        else:
            print(f'Format {f} not implemented')

        tms.append(t)

    config = {'entities': tms}
    os.chdir(path_mapp)
    with open(f'config_{distribution["name"]}.json', 'w') as outfile:
        json.dump(config, outfile)

    p = os.path.join('/tmp/output/datasets/', distribution['name'],
                     f'mapping.{distribution["name"]}.nt')
    os.system(f'python3 app.py -c config_{distribution["name"]}.json '
              f'-o {p} > /dev/null')


def signal_handler(sig, frame):
    print('\nBye! ')
    sys.exit(0)


def apply_updates(size, seed, additions, modifications, deletions):
    print(f'Applying updates on size {size} with seed {seed}')

    try:
        seed = abs(int(seed))
        random.seed(seed)
    except Exception:
        print('\tRandom seed must be an integer, skipping updates')
        return

    trip_id_counter = 0
    route_id_counter = 0
    shape_id_counter = 0
    service_id_counter = 0
    stop_id_counter = 0
    routes2_fd = open('ROUTES-CHANGE.csv', 'w')
    routes_writer = csv.writer(routes2_fd)
    trips2_fd = open('TRIPS-CHANGE.csv', 'w')
    trips_writer = csv.writer(trips2_fd)
    shapes2_fd = open('SHAPES-CHANGE.csv', 'w')
    shapes_writer = csv.writer(shapes2_fd)
    service2_fd = open('CALENDAR-CHANGE.csv', 'w')
    service_writer = csv.writer(service2_fd)
    stoptimes2_fd = open('STOP_TIMES-CHANGE.csv', 'w')
    stoptimes_writer = csv.writer(stoptimes2_fd)
    stops2_fd = open('STOPS-CHANGE.csv', 'w')
    stops_writer = csv.writer(stops2_fd)
    number_of_routes = 0

    # Copy stoptimes, stops, and shapes as they are only appended
    with open('SHAPES.csv', 'r') as shapes_fd:
        reader = csv.reader(shapes_fd)
        for row in reader:
            shapes_writer.writerow(row)

    with open('STOP_TIMES.csv', 'r') as stoptimes_fd:
        reader = csv.reader(stoptimes_fd)
        for row in reader:
            stoptimes_writer.writerow(row)

    with open('STOPS.csv', 'r') as stops_fd:
        reader = csv.reader(stops_fd)
        for row in reader:
            stops_writer.writerow(row)

    # Deletions: delete routes and associated data with it
    print(f'\tDeletions: {deletions}%')
    route_ids = []
    # Pick randomly X% of the routes to delete
    with open('ROUTES.csv', 'r') as routes_fd:
        reader = csv.reader(routes_fd)
        next(reader)  # header
        rows = []

        for r in reader:
            rows.append(r)
        number_of_routes = len(rows)

        if deletions > 0:
            for i in range(0, int(((deletions/100) * number_of_routes) + 1)):
                while (True):
                    picked = random.choice(rows)[0]
                    if picked not in route_ids:
                        route_ids.append(picked)
                        break

    # Delete all trips for this route
    with open('TRIPS.csv', 'r') as trips_fd:
        reader = csv.reader(trips_fd)
        for row in reader:
            if row[0] not in route_ids:
                trips_writer.writerow(row)

    # Delete route
    with open('ROUTES.csv', 'r') as routes_fd:
        reader = csv.reader(routes_fd)
        for row in reader:
            if row[0] not in route_ids:
                routes_writer.writerow(row)

    # Modifications: modify a service of a trip
    service_ids = []
    print(f'\tModifications: {modifications}%')
    if modifications > 0:
        with open('CALENDAR.csv', 'r') as services_fd:
            reader = csv.reader(services_fd)
            row = next(reader)  # header
            service_writer.writerow(row)

            # Pick random service IDs
            rows = []
            for r in reader:
                rows.append(r)

            for i in range(0, int(((modifications/100) * len(rows)) + 1)):
                while (True):
                    picked = random.choice(rows)[0]
                    if picked not in service_ids:
                        service_ids.append(picked)
                        break

        # Modify each picked service by generating random values for days and dates
        # Services which are not picked are left unmodified
        with open('CALENDAR.csv', 'r') as services_fd:
            reader = csv.reader(services_fd)
            next(reader)  # header
            for row in reader:
                if row[0] in service_ids:
                    monday = random.randint(0, 1)
                    tuesday = random.randint(0, 1)
                    wednesday = random.randint(0, 1)
                    thursday = random.randint(0, 1)
                    friday = random.randint(0, 1)
                    saturday = random.randint(0, 1)
                    sunday = random.randint(0, 1)
                    year = random.randint(2017, 2023)
                    start_date = f'{year}-{random.randint(1, 12):02d}-' + \
                        f'{random.randint(1, 31):02d}'
                    end_date = f'{year + 1}-{random.randint(1, 12):02d}-' + \
                        f'{random.randint(1, 31):02d}'
                    service_writer.writerow([row[0], monday, tuesday, wednesday,
                                             thursday, friday, saturday, sunday,
                                             start_date, end_date])
                else:
                    service_writer.writerow(row)

    # Additions: add route and associated data with it.
    print(f'\tAdditions: {additions}%')
    if additions > 0:
        for i in range(0, int(((additions/100) * number_of_routes) + 1)):
            # Route
            route_id = f'ROUTE{seed}{route_id_counter}'
            route_id_counter += 1
            route_short_name = f'add{i}'
            route_long_name = f'addition{i}'
            route_url = 'http://www.crtm.es/tu-transporte-publico/metro' + \
                        f'/lineas/addition{i}.aspx'
            route_color = str(random.randint(1, 10))
            route_text_color = str(random.randint(1, 10))
            agency_id = 1
            route_desc = route_id
            route_type = 1
            routes_writer.writerow([route_id, agency_id, route_short_name,
                                    route_long_name, route_desc, route_type,
                                    route_url, route_color, route_text_color])

            # Add shape for route
            shape_id = f'SHAPE{seed}{shape_id_counter}'
            shape_id_counter += 1
            shape_pt_lat = random.randint(1, 100000)
            shape_pt_lon = random.randint(1, 100000)
            shape_pt_sequence = random.randint(1, 100000)
            shape_dist_traveled = random.randint(1, 100000)
            shapes_writer.writerow([shape_id, shape_pt_lat, shape_pt_lon,
                                    shape_pt_sequence, shape_dist_traveled])

            # Add service calendar for route
            service_id = f'SERVICE{seed}{service_id_counter}'
            service_id_counter += 1
            year = random.randint(2017, 2023)
            start_date = f'{year}-{random.randint(1, 12):02d}-' + \
                f'{random.randint(1, 31):02d}'
            end_date = f'{year + 1}-{random.randint(1, 12):02d}-' + \
                f'{random.randint(1, 31):02d}'
            service_writer.writerow([service_id, 1, 1, 1, 1, 1, 1, 1, start_date,
                                     end_date])

            # Add trips for route with their corresponding stop times
            for j in range(random.randrange(seed+1, seed+15)):
                trip_id = f'TRIP{seed}{trip_id_counter}'
                trip_id_counter += 1
                trip_headsign = 'addition'
                trip_short_name = 'add'
                direction_id = '0'
                block_id = str(random.randint(0, 100))
                wheelchair_accessible = '1'
                trips_writer.writerow([route_id, service_id, trip_id,
                                       trip_headsign, trip_short_name,
                                       direction_id, block_id, shape_id,
                                       wheelchair_accessible])

                for k in range(random.randrange(seed+1, seed+10)):
                    # Stop
                    stop_id = f'STOP{seed}{stop_id_counter}'
                    stop_id_counter += 1
                    stop_code = f'code{stop_id}'
                    stop_name = f'name_{stop_id}'
                    stop_desc = f'desc_{stop_id}'
                    stop_lat = random.randint(0, 10000)
                    stop_lon = random.randint(0, 10000)
                    zone_id = ''
                    stop_url = 'http://www.crtm.es'
                    location_type = random.randint(0, 3)
                    parent_station = ''
                    stop_timezone = ''
                    wheelchair_boarding = random.randint(0, 3)
                    stops_writer.writerow([stop_id, stop_code, stop_name,
                                           stop_desc, stop_lat, stop_lon, zone_id,
                                           stop_url, location_type, parent_station,
                                           stop_timezone, wheelchair_boarding])

                    # Stop times
                    arrival_time = random.randint(0, 1000)
                    departure_time = arrival_time + random.randint(0, 1000)
                    stop_sequence = ''
                    stop_headsign = f'headsign{seed}-{j}-{k}'
                    pickup_type = 0
                    drop_off_type = 0
                    shape_dist_traveled = random.randint(0, 10000)
                    stoptimes_writer.writerow([trip_id, arrival_time,
                                               departure_time, stop_id,
                                               stop_sequence, stop_headsign,
                                               pickup_type, drop_off_type,
                                               shape_dist_traveled])

    routes2_fd.close()
    trips2_fd.close()
    shapes2_fd.close()
    service2_fd.close()
    stoptimes2_fd.close()
    stops2_fd.close()

    # Replace original files with updated files
    shutil.move('ROUTES-CHANGE.csv', 'ROUTES.csv')
    shutil.move('TRIPS-CHANGE.csv', 'TRIPS.csv')
    shutil.move('SHAPES-CHANGE.csv', 'SHAPES.csv')
    shutil.move('CALENDAR-CHANGE.csv', 'CALENDAR.csv')
    shutil.move('STOP_TIMES-CHANGE.csv', 'STOP_TIMES.csv')
    shutil.move('STOPS-CHANGE.csv', 'STOPS.csv')


signal.signal(signal.SIGINT, signal_handler)

print(colored('''
   mmm mmmmmmm mmmmmm  mmmm         mmmmm  mmmmmm mm   m   mmm  m    m
 m"   "   #    #      #"   "        #    # #      #"m  # m"   " #    #
 #   mm   #    #mmmmm "#mmm         #mmmm" #mmmmm # #m # #      #mmmm#
 #    #   #    #          "#  """   #    # #      #  # # #      #    #
  "mmm"   #    #      "mmm#"        #mmmm" #mmmmm #   ##  "mmm" #    #

This script will guide in the generation of benchmarking datasets and mappings
based on the GTFS transport data format.

''', 'red'))


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

        ]

    }
]

q4 = [
    {
        'type': 'input',
        'name': 'q',
        'message': 'Updates seed, number of additions, number of modifications, and number of deletions, separated by commas. Leave empty to skip:',
    }
]

sizes = [int(x) for x in map(int, prompt(q2, style=custom_style_3)['q'].split(','))]

while True:
    q3_a = prompt(q3)['q']
    if len(q3_a) > 0:
        break
    else:
        print('Select at least one distribution format!')

distributions = list()

for a in q3_a:
    if a == 'custom':
        distributions.append(custom_distribution())
    else:
        distributions.append(static_distributions[a])

# Data
create_file_structure(sizes, distributions)

for s in sizes:
    print(f'Generating dataset at scale: {s}')
    os.system(f'{path_gen}./generate.sh {s} {path_gen}')
    os.chdir(os.path.join(path_gen, 'resources/csvs/'))
    os.makedirs('dist', exist_ok=True)
    updates = []
    has_updates = False

    try:
        updates = [int(x) for x in map(int, prompt(q4, style=custom_style_3)['q'].split(','))]
        seed = updates[0]
        additions = updates[1]
        modifications = updates[2]
        deletions = updates[3]

        if additions not in range(0, 100+1):
            raise ValueError('Additions must be a percentage [0, 100]%')
        elif modifications not in range(0, 100+1):
            raise ValueError('Modifications must be a percentage [0, 100]%')
        elif deletions not in range(0, 100+1):
            raise ValueError('Deletions must be a percentage [0, 100]%')

        has_updates = True
    except ValueError as e:
        print(e)
        sys.exit(1)
    except Exception:
        has_updates = False

    if has_updates:
        print('Applying updates')
        apply_updates(s, seed, additions, modifications, deletions)
    else:
        print('Skipping updates')

    for d in distributions:
        generate_distribution(s, d)
        generate_sql_schema(d, s)

    shutil.rmtree('dist')

# Cleanup
os.system('echo \'DROP DATABASE `gtfs`\' | mysql -u root')

# Mapping
for d in distributions:
    generate_mapping(d)

# Move
print('Compressing output: result.tar.xz...', end='', flush=True)

os.chdir(base_path)
os.system('cp ./queries/vig/*.rq /tmp/output/queries/')
os.chdir('/tmp/output/')
os.system('rm -f /output/result.tar.xz')
os.system('tar Oc . | pxz -1 -cv - > /output/result.tar.xz')

print('Done!')
print(colored('The generated data is in the result.tar.xz file '
              'at the current path.', 'blue'))
print('Press Ctrl+C to exit')
signal.pause()
