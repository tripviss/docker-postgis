#!/bin/bash
set -e

# Create the 'template_postgis' template db
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<- 'EOSQL'
CREATE DATABASE template_postgis;
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis';
EOSQL

# Load PostGIS into both template_postgis and $POSTGRES_DB
for db in template_postgis "$POSTGRES_DB"; do
	echo "Loading PostGIS extensions into $db"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname="$db" <<-'EOSQL'
		CREATE EXTENSION IF NOT EXISTS postgis;
		CREATE EXTENSION IF NOT EXISTS postgis_topology;
		CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
		CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;
EOSQL
done
