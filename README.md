# Experimental evaluation of GTFS-Madrid-Bench v1.1.0

Resources used for the experimental evaluation shown in the publication David Chaves-Fraga, Freddy Priyatna, Andrea Cimmino, Jhon Toledo, Edna Ruckhaus, & Oscar Corcho (2020). GTFS-Madrid-Bench: A benchmark for virtual knowledge graph access in the transport domain. Journal of Web Semantics, 65. [Online](https://doi.org/10.1016/j.websem.2020.100596).

- Docker and docker-compose must be installed to use the benchmark.

- The engines tested were: Ontop, Morph-RDB, Morph-CSV, Morph-xR2RML and Ontario. We provide a docker compose to deploy the version of the engine used in the experimental evaluation, see the folder **engines**.

- The data used was generated using VIG 1.8.0. See folder **generation** to create your own datasets. They will be distributed in CSV, JSON (can be also loaded in MongoDB), XML and RDB, for custom dataset, please use GTFS-Madrid-Bench v1.5.

- The scripts for loading the datasets in the databases are located in **loading-scripts** folder. 

- The mappings and queries used in the evaluation and the results obtained are located in their corresponding folders.


The workflow for reproduce the results of the paper is:
- Go to the **generation** folder and run `run.sh`
- Copy the generated zip files to the **loading-scripts** folder and run `data-prepration.sh`
- Go to **engines** folder and run `docker-compose up -d`
- Create a network bridge in docker between databases containers and engines containers.
- Go inside the docker container of each engine and run the evaluation scripts.




**We provide this resources in the case anyone wants to reproduce the experiments shown in the publication, for a proper use of the benchmark, please go to the master folder and use the custom generator engine with the updated resources.**