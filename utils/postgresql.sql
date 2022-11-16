DROP TABLE IF EXISTS stop_times CASCADE;
DROP TABLE IF EXISTS frequencies CASCADE;
DROP TABLE IF EXISTS trips CASCADE;
DROP TABLE IF EXISTS routes CASCADE;
DROP TABLE IF EXISTS calendar_dates CASCADE;
DROP TABLE IF EXISTS calendar CASCADE;
DROP TABLE IF EXISTS feed_info CASCADE;
DROP TABLE IF EXISTS shapes CASCADE;
DROP TABLE IF EXISTS stops CASCADE;
DROP TABLE IF EXISTS agency CASCADE;

CREATE TABLE agency ("agency_id" VARCHAR(200),
"agency_name" VARCHAR(200),
"agency_url" VARCHAR(200),
"agency_timezone" VARCHAR(200),
"agency_lang" VARCHAR(200),
"agency_phone" VARCHAR(200) DEFAULT NULL,
"agency_fare_url" VARCHAR(200) DEFAULT NULL,
PRIMARY KEY (agency_id));

COPY agency FROM '/data/AGENCY.csv' DELIMITER ',' CSV HEADER;
UPDATE agency SET agency_phone = NULL where agency_phone ='';
UPDATE agency SET agency_fare_url = NULL where agency_fare_url ='';

CREATE TABLE calendar_dates ("service_id" VARCHAR(200),
"date" DATE,
"exception_type" INT,
PRIMARY KEY (service_id,date));

COPY calendar_dates FROM '/data/CALENDAR_DATES.csv'  DELIMITER ',' CSV HEADER;
UPDATE calendar_dates SET exception_type = 0 WHERE exception_type = 2;

CREATE TABLE calendar ("service_id" VARCHAR(200),
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

COPY calendar FROM '/data/CALENDAR.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE feed_info ("feed_publisher_name" VARCHAR(200),
"feed_publisher_url" VARCHAR(200),
"feed_lang" VARCHAR(200),
"feed_start_date" DATE DEFAULT NULL,
"feed_end_date" DATE DEFAULT NULL,
"feed_version" VARCHAR(200),
PRIMARY KEY (feed_publisher_name));

COPY feed_info FROM '/data/FEED_INFO.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE frequencies ("trip_id" VARCHAR(200),
"start_time" VARCHAR(200),
"end_time" VARCHAR(200),
"headway_secs" INT,
"exact_times" INT DEFAULT 0,
PRIMARY KEY (trip_id,start_time));

COPY frequencies FROM '/data/FREQUENCIES.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE routes ("route_id" VARCHAR(200),
"agency_id" VARCHAR(200),
"route_short_name" VARCHAR(200),
"route_long_name" VARCHAR(200),
"route_desc" VARCHAR(200) DEFAULT NULL,
"route_type" INT,
"route_url" VARCHAR(200),
"route_color" VARCHAR(200),
"route_text_color" VARCHAR(200),
PRIMARY KEY (route_id));

COPY routes FROM '/data/ROUTES.csv' DELIMITER ',' CSV HEADER;
UPDATE routes SET route_desc = NULL where route_desc ='';

CREATE TABLE shapes ("shape_id" VARCHAR(200),
"shape_pt_lat" INT,
"shape_pt_lon" INT,
"shape_pt_sequence" INT,
"shape_dist_traveled" INT,
PRIMARY KEY (shape_id,shape_pt_sequence));

COPY shapes FROM '/data/SHAPES.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE stops ("stop_id" VARCHAR(200),
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

COPY stops FROM '/data/STOPS.csv' DELIMITER ',' CSV HEADER;
UPDATE stops SET zone_id = NULL where zone_id ='';
UPDATE stops SET stop_timezone = NULL where stop_timezone ='';
UPDATE stops SET parent_station = NULL where parent_station ='';

ALTER TABLE stops ADD FOREIGN KEY (parent_station) REFERENCES stops (stop_id);

CREATE TABLE stop_times ("trip_id" VARCHAR(200),
"arrival_time" VARCHAR(200),
"departure_time" VARCHAR(200),
"stop_id" VARCHAR(200),
"stop_sequence" INT,
"stop_headsign" VARCHAR(200),
"pickup_type" INT DEFAULT 0,
"drop_off_type" INT DEFAULT 0,
"shape_dist_traveled" INT,
PRIMARY KEY (trip_id,stop_id,arrival_time));

COPY stop_times FROM '/data/STOP_TIMES.csv' DELIMITER ',' CSV HEADER;
UPDATE stop_times SET trip_id = NULL where trip_id ='';
UPDATE stop_times SET arrival_time = NULL where arrival_time ='';
UPDATE stop_times SET departure_time = NULL where departure_time ='';
UPDATE stop_times SET stop_id = NULL where stop_id ='';
UPDATE stop_times SET stop_headsign = NULL where stop_headsign ='';

CREATE TABLE trips ("route_id" VARCHAR(200),
"service_id" VARCHAR(200),
"trip_id" VARCHAR(200),
"trip_headsign" VARCHAR(200),
"trip_short_name" VARCHAR(200),
"direction_id" INT,
"block_id" VARCHAR(200) DEFAULT NULL,
"shape_id" VARCHAR(200),
"wheelchair_accessible" INT,
PRIMARY KEY (trip_id));

COPY trips FROM  '/data/TRIPS.csv'  DELIMITER ',' CSV HEADER;
UPDATE trips SET block_id = NULL where block_id ='';

ALTER TABLE frequencies ADD FOREIGN KEY (trip_id) REFERENCES trips (trip_id);
ALTER TABLE routes ADD FOREIGN KEY (agency_id) REFERENCES agency (agency_id);
ALTER TABLE stop_times ADD FOREIGN KEY (stop_id) REFERENCES stops (stop_id);
ALTER TABLE stop_times  ADD FOREIGN KEY (trip_id) REFERENCES trips (trip_id);
-- ALTER TABLE trips ADD FOREIGN KEY (shape_id) REFERENCES shapes (shape_id);
ALTER TABLE trips ADD FOREIGN KEY (route_id) REFERENCES routes (route_id);
-- ALTER TABLE trips ADD FOREIGN KEY (service_id) REFERENCES calendar (service_id);
-- ALTER TABLE trips ADD FOREIGN KEY (service_id) REFERENCES calendar_dates (service_id);
