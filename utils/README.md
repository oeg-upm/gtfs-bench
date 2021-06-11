# Utils for running the engines with GTFS-Madrid-Bench


## Loading data in the database
We highly recommended to use the following commands, for MySQL:
- Docker:
```bash
docker exec -i gtfs-mysql sh -c 'exec mysql --local-infile -uroot -ppassword' < gtfs_schema.sql
```
- Local:
```bash
mysql --local-infile -u root -p < gtfs_schema.sql
```


## Running the engine
- **docker-compose.yml**: template with a possible configuration for running the engine
- **config.json**: configuration file that allows you to configure how to run the engine in a specific setup. It includes: number of rounds you want to execute the configuration, the command to run the engines and the path of the expected output results.
- **evaluate.py**: python script that uses config.json to execute the engine in the desirable configuration, results include (to appear in result_times.csv): run, elapsed_time, kernel_mode, user_mode, memory_max, memory_average, number_results. The number of results counts the number of lines in the output file.

 
