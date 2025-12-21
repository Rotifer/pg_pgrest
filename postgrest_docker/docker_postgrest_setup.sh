#!/bin/bash


docker run -d \
  --name postgrest \
  -p 3001:3001 \
  -e PGRST_DB_URI="postgres://admin:postgrest_admin_pwd@host.docker.internal:5432/pgrest" \
  -e PGRST_DB_SCHEMA="api" \
  -e PGRST_DB_ANON_ROLE="web_anon" \
  postgrest/postgrest

