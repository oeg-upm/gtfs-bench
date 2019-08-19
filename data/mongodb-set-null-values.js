use gtfs1
db.AGENCY.updateMany({"agency_phone":""}, { $set: {"agency_phone":null} } )
db.AGENCY.updateMany({"agency_fare_url":""}, { $set: {"agency_fare_url":null} } )
db.ROUTES.updateMany({"route_desc":""}, { $set: {"route_desc":null} } )
db.STOPS.updateMany({"stop_desc":""}, { $set: {"stop_desc":null} } )
db.STOPS.updateMany({"stop_timezone":""}, { $set: {"stop_timezone":null} } )
db.TRIPS.updateMany({"block_id":""}, { $set: {"block_id":null} } )
