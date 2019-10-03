# The Madrid-GTFS-Bench

We present the Madrid-GTFS-Bench, a benchmarking for virutal knowledge graph access in the transport domain. We use the de-facto standard model for publishing open data on web, GTFS, and we scale up and distribute the original dataset in several formats and sizes. This repository contains the following resources:

- Data: we have generated from several datasets(GTFS-[1,5,10,50,100,500]) in multiple formats (CSV, JSON, XML, SQL, MongoDB). The preparation script will download all these datasets and generate a docker-image for each dataset which is contained in a database (MySQL and MongoDB)
- Generation: If any practicioner or developer want to create datasets with other scale values all the resources are available.
- Queries: 18 queries increasing in terms of complexity.
- Mappings: 1 R2RML mapping document, 7 RML mapping document, 1 xR2RML mapping document, 1 YARRRML mapping and 1 CSVW annotations
- Engines: docker-compose with all the tested engines and running scripts


## Authors

- David Chaves-Fraga
- Freddy Priyatna
- Jhon Toledo
- Edna Ruckhaus
- Andrea Cimmino
- Oscar Corcho

Ontology Engineering Group, October 2019
