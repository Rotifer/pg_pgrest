# Notes on PostgREST

## Setting up PostgREST locally

## Installing PostgREST

Downloaded __postgrest-v14.1-linux-static-x86-64.tar.xz__ from [PostgREST site](https://github.com/PostgREST/postgrest/releases/tag/v14.1)

```{sh}
tar -xJf postgrest-v14.1.tar.xz
chmod +x postgrest
sudo mv postgrest /usr/local/bin/
postgrest --version
```


## Setting up a PostgREST database, schema and user

```{sql}
-- Logged in as superuser postgres
CREATE DATABASE pgrest;
\c pgrest
CREATE USER pgrest LOGIN PASSWORD 'pgrest';
CREATE SCHEMA pgrest;
GRANT USAGE ON SCHEMA pgrest TO pgrest;
-- Only giving access to stored procedures
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA pgrest TO pgrest;
```

## Configure PostgREST

Contents of file /etc/postgrest.conf:

```
# Database connection string
db-uri = "postgres://pgrest:pgrest@localhost:5432/pgrest"

# Which schema(s) to expose via the API
db-schema = "pgrest"

# Role used for anonymous requests
db-anon-role = "pgrest"

# Server settings
server-host = "!4"   # Listen on all IPv4 addresses
server-port = 3000

```

## Testing PostgREST

Start the PostgREST server:

```{sh}
postgrest /etc/postgrest.conf
```

Create a function in the schema set up for PostgREST end points:

```{sql}
CREATE OR REPLACE FUNCTION pgrest.test_user()
RETURNS TEXT AS
$$
SELECT FORMAT('the current user is: %s', CURRENT_USER);
$$
LANGUAGE SQL;
```

The function was created by user _postgres_.
Testing it while logged in to psql and connected to the pgrest database:

```{sql}
SELECT * FROM pgrest.test_user();
```

Returns _postgres_.

Let's test it from PostgREST:

```{sh}
curl http://localhost:3000/rpc/test_user
```

The output os _"the current user is: pgrest"$_

As expected.

## Setting up an Nginx Reverse Proxy

The nginx reverse proxy version.

http://127.0.0.0:8080/rpc/test_user



