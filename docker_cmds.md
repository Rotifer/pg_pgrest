Only run the following once



```{sh}
docker volume create postgres-volume

docker run --name postgres \
    -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=dbmeister1 \
    -p 5433:5432 \
    -v postgres-volume:/var/lib/postgresql/data \
    -d postgres:17.2
```

Re-start with

```{sh}
docker start  postgres
```

Log in with:

```{sh}
docker exec -it postgres psql -U postgres
```

Getting to the container shell

```{sh}
$ docker exec -it postgres bash
```

Using pg_prove

```{sh}
# pg_prove -U postgres -d postgres tests/*
```


Connecting to the new database as


## JSON

Download the [Hugo JSON file](https://storage.googleapis.com/public-download-files/hgnc/json/json/locus_types/gene_with_protein_product.json).

Extract the gene JSONs to one gene JSON per line.

```{sh}
jq -c '.response.docs[]' gene_with_protein_product.json >genes.json
```

Copy the genes.json to the postgres docker instance

```{sh}
docker cp genes.json postgres:/home/.
```

```{sh}
docker exec -it postgres psql -U postgres
postgres=# CREATE SCHEMA genes;
postgres=# CREATE TABLE genes.scratch(gene_json TEXT);
postgres=# COPY genes.scratch FROM '/home/genes.json';
```


## Full text search and _pg_search_


Docker compose file _docker-compose.yml_

```{yaml}
services:
  paradedb:
    image: paradedb/paradedb:latest
    container_name: paradedb
    ports:
      - "5434:5432"
    environment:
      POSTGRES_PASSWORD: postgres
```

Saved into directory: _/home/${USER}/paradedb_

to get the container running:

```{sh}
docker compose up -d
```

To confirm that it is running: `docker ps`

```{sh}
docker exec -it paradedb bash
psql -U postgres
```




