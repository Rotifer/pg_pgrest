# Setting up the database and accounts

```sql
-- $ docker exec -it postgrest psql -U postgres

CREATE ROLE admin WITH LOGIN CREATEROLE CREATEDB PASSWORD 'postgrest_admin_pwd';

-- $ docker exec -it postgrest psql -U admin -d postgres

CREATE DATABASE pgrest;
postgres=> \c pgrest
CREATE SCHEMA lab_data;
COMMENT ON SCHEMA lab_data IS 'Stores the actual data in base tables. Not visible to PostgREST.';
CREATE SCHEMA api;
COMMENT ON SCHEMA api IS 'The schema exposed to PostgREST.';
```
