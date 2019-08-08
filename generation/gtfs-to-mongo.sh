mongoimport --db gtfs1 --collection AGENCY --file AGENCY.json --jsonArray
mongoimport --db gtfs1 --collection STOPS --file STOPS.json --jsonArray
mongoimport --db gtfs1 --collection ROUTES --file ROUTES.json --jsonArray
mongoimport --db gtfs1 --collection CALENDAR --file CALENDAR.json --jsonArray