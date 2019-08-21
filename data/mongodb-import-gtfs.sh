mongoimport --db gtfs --collection AGENCY --file AGENCY.json --jsonArray
mongoimport --db gtfs --collection STOPS --file STOPS.json --jsonArray
mongoimport --db gtfs --collection ROUTES --file ROUTES.json --jsonArray
mongoimport --db gtfs --collection CALENDAR --file CALENDAR.json --jsonArray
mongoimport --db gtfs --collection CALENDAR_DATES --file CALENDAR_DATES.json --jsonArray
mongoimport --db gtfs --collection TRIPS --file TRIPS.json --jsonArray
mongoimport --db gtfs --collection STOP_TIMES --file STOP_TIMES.json --jsonArray
mongoimport --db gtfs --collection FEED_INFO --file FEED_INFO.json --jsonArray
mongoimport --db gtfs --collection FREQUENCIES --file FREQUENCIES.json --jsonArray
mongoimport --db gtfs --collection SHAPES --file SHAPES.json --jsonArray

mongo < mongodb-set-null-values.js
