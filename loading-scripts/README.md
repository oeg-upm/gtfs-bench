# How to load the data?

- Install docker (with user permissions), docker-compose (with user permissions), unzip.
- Copy the files obtained in the generation phase to this folder (zip files).
- Run data-preparation.sh: it unzips and prepares the databases and plain files (CSV,JSON,XML) to be queried
- It is recommended to run this step in background (nohup ./data-preparation &)

```bash
nohup ./data-preparation.sh &
```
