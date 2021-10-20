
DROP TABLE IF EXISTS AGENCY;

CREATE TABLE AGENCY ("agency_id" VARCHAR(200),
"agency_name" VARCHAR(200),
"agency_url" VARCHAR(200),
"agency_timezone" VARCHAR(200),
"agency_lang" VARCHAR(200),
"agency_phone" VARCHAR(200) DEFAULT NULL,
"agency_fare_url" VARCHAR(200) DEFAULT NULL,
PRIMARY KEY (agency_id));

COPY AGENCY FROM '/data/AGENCY.csv' DELIMITER ',' CSV HEADER;
UPDATE AGENCY SET agency_phone = NULL where agency_phone ='';
UPDATE AGENCY SET agency_fare_url = NULL where agency_fare_url ='';


DROP TABLE IF EXISTS CALENDAR_DATES;
CREATE TABLE CALENDAR_DATES ("service_id" VARCHAR(200),
"date" DATE,
"exception_type" INT,
PRIMARY KEY (service_id,date));

COPY CALENDAR_DATES FROM '/data/CALENDAR_DATES.csv'  DELIMITER ',' CSV HEADER;
UPDATE CALENDAR_DATES SET exception_type = 0 WHERE exception_type = 2;

DROP TABLE IF EXISTS CALENDAR;
CREATE TABLE CALENDAR ("service_id" VARCHAR(200),
"monday" INT,
"tuesday" INT,
"wednesday" INT,
"thursday" INT,
"friday" INT,
"saturday" INT,
"sunday" INT,
"start_date" DATE,
"end_date" DATE DEFAULT NULL,
PRIMARY KEY (service_id));

COPY CALENDAR FROM '/data/CALENDAR.csv' DELIMITER ',' CSV HEADER;

DROP TABLE IF EXISTS FEED_INFO;
CREATE TABLE FEED_INFO ("feed_publisher_name" VARCHAR(200),
"feed_publisher_url" VARCHAR(200),
"feed_lang" VARCHAR(200),
"feed_start_date" DATE DEFAULT NULL,
"feed_end_date" DATE DEFAULT NULL,
"feed_version" VARCHAR(200),
PRIMARY KEY (feed_publisher_name));

COPY FEED_INFO FROM '/data/FEED_INFO.csv' DELIMITER ',' CSV HEADER;


DROP TABLE IF EXISTS FREQUENCIES;
CREATE TABLE FREQUENCIES ("trip_id" VARCHAR(200),
"start_time" VARCHAR(200),
"end_time" VARCHAR(200),
"headway_secs" INT,
"exact_times" INT DEFAULT 0,
PRIMARY KEY (trip_id,start_time));

COPY FREQUENCIES FROM '/data/FREQUENCIES.csv' DELIMITER ',' CSV HEADER;


DROP TABLE IF EXISTS ROUTES;
CREATE TABLE ROUTES ("route_id" VARCHAR(200),
"agency_id" VARCHAR(200),
"route_short_name" VARCHAR(200),
"route_long_name" VARCHAR(200),
"route_desc" VARCHAR(200) DEFAULT NULL,
"route_type" INT,
"route_url" VARCHAR(200),
"route_color" VARCHAR(200),
"route_text_color" VARCHAR(200),
PRIMARY KEY (route_id));

COPY ROUTES FROM '/data/ROUTES.csv' DELIMITER ',' CSV HEADER;
UPDATE ROUTES SET route_desc = NULL where route_desc ='';


DROP TABLE IF EXISTS SHAPES;
CREATE TABLE SHAPES ("shape_id" VARCHAR(200),
"shape_pt_lat" INT,
"shape_pt_lon" INT,
"shape_pt_sequence" INT,
"shape_dist_traveled" INT,
PRIMARY KEY (shape_id,shape_pt_sequence));

COPY SHAPES FROM '/data/SHAPES.csv' DELIMITER ',' CSV HEADER;


DROP TABLE IF EXISTS STOPS;
CREATE TABLE STOPS ("stop_id" VARCHAR(200),
"stop_code" VARCHAR(200),
"stop_name" VARCHAR(200),
"stop_desc" VARCHAR(200),
"stop_lat" DECIMAL(18,15),
"stop_lon" DECIMAL(18,15),
"zone_id" VARCHAR(200),
"stop_url" VARCHAR(200),
"location_type" INT,
"parent_station" VARCHAR(200),
"stop_timezone" VARCHAR(200) DEFAULT NULL,
"wheelchair_boarding" INT,
PRIMARY KEY (stop_id));

COPY STOPS FROM '/data/STOPS.csv' DELIMITER ',' CSV HEADER;
UPDATE STOPS SET zone_id = NULL where zone_id ='';
UPDATE STOPS SET stop_timezone = NULL where stop_timezone ='';
UPDATE STOPS SET parent_station = NULL where parent_station ='';

ALTER TABLE  STOPS ADD FOREIGN KEY (parent_station) REFERENCES STOPS (stop_id);



DROP TABLE IF EXISTS STOP_TIMES;
CREATE TABLE STOP_TIMES ("trip_id" VARCHAR(200),
"arrival_time" VARCHAR(200),
"departure_time" VARCHAR(200),
"stop_id" VARCHAR(200),
"stop_sequence" INT,
"stop_headsign" VARCHAR(200),
"pickup_type" INT DEFAULT 0,
"drop_off_type" INT DEFAULT 0,
"shape_dist_traveled" INT,
PRIMARY KEY (trip_id,stop_id,arrival_time));

COPY STOP_TIMES FROM '/data/STOP_TIMES.csv' DELIMITER ',' CSV HEADER;
UPDATE STOP_TIMES SET trip_id = NULL where trip_id ='';
UPDATE STOP_TIMES SET arrival_time = NULL where arrival_time ='';
UPDATE STOP_TIMES SET departure_time = NULL where departure_time ='';
UPDATE STOP_TIMES SET stop_id = NULL where stop_id ='';
UPDATE STOP_TIMES SET stop_headsign = NULL where stop_headsign ='';


DROP TABLE IF EXISTS TRIPS;
CREATE TABLE TRIPS ("route_id" VARCHAR(200),
"service_id" VARCHAR(200),
"trip_id" VARCHAR(200),
"trip_headsign" VARCHAR(200),
"trip_short_name" VARCHAR(200),
"direction_id" INT,
"block_id" VARCHAR(200) DEFAULT NULL,
"shape_id" VARCHAR(200),
"wheelchair_accessible" INT,
PRIMARY KEY (trip_id));

COPY TRIPS FROM  '/data/TRIPS.csv'  DELIMITER ',' CSV HEADER;
UPDATE TRIPS SET block_id = NULL where block_id ='';


ALTER TABLE  FREQUENCIES  ADD FOREIGN KEY (trip_id) REFERENCES TRIPS (trip_id);
ALTER TABLE  ROUTES  ADD FOREIGN KEY (agency_id) REFERENCES AGENCY (agency_id);
ALTER TABLE  STOP_TIMES  ADD FOREIGN KEY (stop_id) REFERENCES STOPS (stop_id);
ALTER TABLE  STOP_TIMES  ADD FOREIGN KEY (trip_id) REFERENCES TRIPS (trip_id);
ALTER TABLE  TRIPS ADD FOREIGN KEY (route_id) REFERENCES ROUTES (route_id);
