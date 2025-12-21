#!/bin/bash


docker run --name postgrest \
    -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=$PG_POSTGREST_DOCKER_PWD \
    -p $PG_POSTGREST_DOCKER_PORT:5432 \
    -v pg18-data:/var/lib/postgresql \
    -d postgres:18
