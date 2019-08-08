mongoimport --db gtfs1 --collection AGENCY --file AGENCY.json --jsonArray
mongoimport --db gtfs1 --collection STOPS --file STOPS.json --jsonArray
mongoimport --db gtfs1 --collection ROUTES --file ROUTES.json --jsonArray
mongoimport --db gtfs1 --collection CALENDAR --file CALENDAR.json --jsonArray
mongoimport --db gtfs1 --collection CALENDAR_DATES --file CALENDAR_DATES.json --jsonArray
mongoimport --db gtfs1 --collection TRIPS --file TRIPS.json --jsonArray
mongoimport --db gtfs1 --collection STOP_TIMES --file STOP_TIMES.json --jsonArray
