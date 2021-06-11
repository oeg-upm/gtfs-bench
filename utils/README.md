# Utils for running the engines with GTFS-Madrid-Bench


- **docker-compose.yml**: template with a possible configuration for running the engine
- **config.json**: configuration file that allows you to configure how to run the engine in a specific configuration
- **evaluate.py**: python script that uses config.json to execute the engine in the desirable configuration, results include (to appear in result_times.csv): run, elapsed_time, kernel_mode, user_mode, memory_max, memory_average, number_results. The number of results counts the number of lines in the output file.

 