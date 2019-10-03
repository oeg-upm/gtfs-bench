# How to load the data?

- Install docker (with user permissions), docker-compose (with user permissions), unzip, wget.
- Run data-preparation.sh: it downloads, unzips and prepares the databases and plain files (CSV,JSON,XML) to be queried
- It is recommended to run this step in background (nohup ./data-preparation &)