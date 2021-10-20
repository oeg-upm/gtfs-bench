OPTIONS(skip=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'CALENDAR_DATES.csv' 
INSERT INTO TABLE "CALENDAR_DATES" 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
service_id,
"date",
exception_type
)
OPTIONS(skip=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'CALENDAR.csv' 
INSERT INTO TABLE "CALENDAR" 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
service_id,
monday,
tuesday,
wednesday,
thursday,
friday,
saturday,
sunday,
start_date "to_date(SUBSTR(:start_date,1,10),'yyyy-mm-dd')",
end_date "to_date(SUBSTR(:end_date,1,10),'yyyy-mm-dd')"
)
OPTIONS(skip=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'FEED_INFO.csv' 
INSERT INTO TABLE "FEED_INFO" 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
feed_publisher_name,
feed_publisher_url,
feed_lang,
feed_start_date,
feed_end_date,
feed_version
)
OPTIONS(skip=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'FREQUENCIES.csv' 
INSERT INTO TABLE "FREQUENCIES" 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
trip_id,
start_time,
end_time,
headway_secs,
exact_times
)
OPTIONS(skip=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'ROUTES.csv' 
INSERT INTO TABLE "ROUTES" 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
route_id,
agency_id,
route_short_name,
route_long_name,
route_desc,
route_type,
route_url,
route_color,
route_text_color
)
OPTIONS(skip=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'SHAPES.csv' 
INSERT INTO TABLE "SHAPES" 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
shape_id,
shape_pt_lat,
shape_pt_lon,
shape_pt_sequence,
shape_dist
)
OPTIONS(skip=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'STOPS.csv' 
INSERT INTO TABLE "STOPS" 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
stop_id,
stop_code,
stop_name,
stop_desc,
stop_lat,
stop_lon,
zone_id,
stop_url,
location_type,
parent_station,
stop_timezone,
wheelchair_boarding
)
OPTIONS(skip=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'STOP_TIMES.csv' 
INSERT INTO TABLE "STOP_TIMES" 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
trip_id,
arrival_time,
departure_time,
stop_id,
stop_sequence,
stop_headsign,
pickup_type,
drop_off_type,
shape_dist_traveled
)
OPTIONS(skip=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'TRIPS.csv' 
INSERT INTO TABLE "TRIPS" 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
route_id,
service_id,
trip_id,
trip_headsign,
trip_short_name,
direction_id,
block_id,
shape_id,
wheelchair_accessible
)