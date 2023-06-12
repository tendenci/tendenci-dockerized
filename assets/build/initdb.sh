#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER $TENDENCI_USER WITH PASSWORD '$TENDENCI_PASS';
    ALTER ROLE "$TENDENCI_USER" SET client_encoding TO 'UTF8';
    ALTER ROLE "$TENDENCI_USER" SET default_transaction_isolation TO 'read committed';
    CREATE DATABASE $TENDENCI_DB WITH OWNER $TENDENCI_USER;
	GRANT ALL PRIVILEGES ON DATABASE "$TENDENCI_DB" TO "$TENDENCI_USER";
EOSQL

psql -d ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$TENDENCI_DB" <<-EOSQL
    CREATE EXTENSION postgis;
    CREATE EXTENSION postgis_topology;
    CREATE EXTENSION fuzzystrmatch;
    CREATE EXTENSION postgis_tiger_geocoder;
EOSQL
