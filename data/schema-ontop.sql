DROP DATABASE IF EXISTS `gtfs`;
SET GLOBAL local_infile = 1;
CREATE DATABASE IF NOT EXISTS `gtfs`;
USE `gtfs`;
DROP TABLE IF EXISTS CALENDAR_DATES;
CREATE TABLE CALENDAR_DATES (`service_id` VARCHAR(200),`date` DATE,`exception_type` INT,PRIMARY KEY (service_id,date));
DROP TABLE IF EXISTS AGENCY;
CREATE TABLE AGENCY (`agency_id` VARCHAR(200),`agency_name` VARCHAR(200),`agency_url` VARCHAR(200),`agency_timezone` VARCHAR(200),`agency_lang` VARCHAR(200),`agency_phone` VARCHAR(200) DEFAULT NULL,`agency_fare_url` VARCHAR(200) DEFAULT NULL,PRIMARY KEY (agency_id));
DROP TABLE IF EXISTS STOPS;
CREATE TABLE STOPS (`stop_id` VARCHAR(200),`stop_code` VARCHAR(200),`stop_name` VARCHAR(200),`stop_desc` VARCHAR(200),`stop_lat` DECIMAL(18,15),`stop_lon` DECIMAL(18,15),`zone_id` VARCHAR(200),`stop_url` VARCHAR(200),`location_type` INT,`parent_station` VARCHAR(200),`stop_timezone` VARCHAR(200) DEFAULT NULL,`wheelchair_boarding` INT,PRIMARY KEY (stop_id));
DROP TABLE IF EXISTS SHAPES;
CREATE TABLE SHAPES (`shape_id` VARCHAR(200),`shape_pt_lat` DECIMAL(18,15),`shape_pt_lon` DECIMAL(18,15),`shape_pt_sequence` INT,`shape_dist` DECIMAL(18,15),PRIMARY KEY (shape_id,shape_pt_sequence));
DROP TABLE IF EXISTS ROUTES;
CREATE TABLE ROUTES (`route_id` VARCHAR(200),`agency_id2` VARCHAR(200),`route_short_name` VARCHAR(200),`route_long_name` VARCHAR(200),`route_desc` VARCHAR(200) DEFAULT NULL,`route_type` INT,`route_url` VARCHAR(200),`route_color` VARCHAR(200),`route_text_color` VARCHAR(200),PRIMARY KEY (route_id));
DROP TABLE IF EXISTS FREQUENCIES;
CREATE TABLE FREQUENCIES (`trip_id2` VARCHAR(200),`start_time` VARCHAR(200),`end_time` VARCHAR(200),`headway_secs` INT,`exact_times` INT DEFAULT 0,PRIMARY KEY (trip_id2,start_time));
DROP TABLE IF EXISTS CALENDAR;
CREATE TABLE CALENDAR (`service_id` VARCHAR(200),`monday` INT,`tuesday` INT,`wednesday` INT,`thursday` INT,`friday` INT,`saturday` INT,`sunday` INT,`start_date` DATE,`end_date` DATE DEFAULT NULL,PRIMARY KEY (service_id));
DROP TABLE IF EXISTS STOP_TIMES;
CREATE TABLE STOP_TIMES (`trip_id2` VARCHAR(200),`arrival_time` VARCHAR(200),`departure_time` VARCHAR(200),`stop_id2` VARCHAR(200),`stop_sequence` INT,`stop_headsign` VARCHAR(200),`pickup_type` INT DEFAULT 0,`drop_off_type` INT DEFAULT 0,`shape_dist_traveled` DECIMAL(18,15),PRIMARY KEY (trip_id2,stop_id2,arrival_time));
DROP TABLE IF EXISTS FEED_INFO;
CREATE TABLE FEED_INFO (`feed_publisher_name` VARCHAR(200),`feed_publisher_url` VARCHAR(200),`feed_lang` VARCHAR(200),`feed_start_date` DATE DEFAULT NULL,`feed_end_date` DATE DEFAULT NULL,`feed_version` VARCHAR(200),PRIMARY KEY (feed_publisher_name));
DROP TABLE IF EXISTS TRIPS;
CREATE TABLE TRIPS (`route_id2` VARCHAR(200),`service_id2` VARCHAR(200),`trip_id` VARCHAR(200),`trip_headsign` VARCHAR(200),`trip_short_name` VARCHAR(200),`direction_id` INT,`block_id` VARCHAR(200) DEFAULT NULL,`shape_id2` VARCHAR(200),`wheelchair_accessible` INT,PRIMARY KEY (trip_id));

LOAD DATA LOCAL INFILE 'AGENCY.csv' INTO TABLE AGENCY FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
       SET agency_phone = IF(agency_phone = '', NULL, agency_phone),
           agency_fare_url = IF(agency_fare_url = '', NULL, agency_fare_url);
LOAD DATA LOCAL INFILE 'STOPS.csv' INTO TABLE STOPS FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
       SET zone_id = IF(zone_id = '', NULL, zone_id),
       stop_timezone = IF(stop_timezone = '', NULL, stop_timezone),
       parent_station = IF(parent_station = '', NULL, parent_station);
LOAD DATA LOCAL INFILE 'SHAPES.csv' INTO TABLE SHAPES FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
LOAD DATA LOCAL INFILE 'ROUTES.csv' INTO TABLE ROUTES FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
       SET route_desc = IF(route_desc = '', NULL, route_desc);
LOAD DATA LOCAL INFILE 'CALENDAR.csv' INTO TABLE CALENDAR FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
       SET end_date = IF(end_date = '', NULL, end_date);
LOAD DATA LOCAL INFILE 'FEED_INFO.csv' INTO TABLE FEED_INFO FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
       SET feed_start_date = IF(feed_start_date = '', NULL, feed_start_date),
       feed_end_date = IF(feed_end_date = '', NULL, feed_end_date);
LOAD DATA LOCAL INFILE 'TRIPS.csv' INTO TABLE TRIPS FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
      SET block_id = IF(block_id = '', NULL, block_id);
LOAD DATA LOCAL INFILE 'FREQUENCIES.csv' INTO TABLE FREQUENCIES FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
      SET exact_times = IF(exact_times='',NULL,exact_times);
LOAD DATA LOCAL INFILE 'STOP_TIMES.csv' INTO TABLE STOP_TIMES FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
       SET trip_id2 = IF(trip_id2 = '', NULL, trip_id2),
           arrival_time = IF(arrival_time = '', NULL, arrival_time),
           departure_time = IF(departure_time = '', NULL, departure_time),
           stop_id2 = IF(stop_id2 = '', NULL, stop_id2),
           stop_sequence = IF(stop_sequence = '', NULL, stop_sequence),
           stop_headsign = IF(stop_headsign = '', NULL, stop_headsign),
       shape_dist_traveled = IF(shape_dist_traveled = '', NULL, shape_dist_traveled);
LOAD DATA LOCAL INFILE 'CALENDAR_DATES.csv' INTO TABLE CALENDAR_DATES FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
      SET exception_type = IF(exception_type=2,0,exception_type);


ALTER TABLE  ROUTES  ADD FOREIGN  KEY (agency_id2) REFERENCES AGENCY (agency_id);
ALTER TABLE  FREQUENCIES  ADD FOREIGN  KEY (trip_id2) REFERENCES TRIPS (trip_id);
ALTER TABLE  STOP_TIMES  ADD FOREIGN  KEY (stop_id2) REFERENCES STOPS (stop_id);
ALTER TABLE  STOP_TIMES  ADD FOREIGN  KEY (trip_id2) REFERENCES TRIPS (trip_id);
ALTER TABLE  STOPS ADD FOREIGN KEY (parent_station) REFERENCES STOPS (stop_id);
ALTER TABLE  TRIPS  ADD FOREIGN  KEY (shape_id2) REFERENCES SHAPES (shape_id);
ALTER TABLE  TRIPS  ADD FOREIGN  KEY (route_id2) REFERENCES ROUTES (route_id);
ALTER TABLE  TRIPS  ADD FOREIGN  KEY (service_id2) REFERENCES CALENDAR (service_id);
ALTER TABLE  TRIPS  ADD FOREIGN KEY (service_id2) REFERENCES CALENDAR_DATES (service_id);