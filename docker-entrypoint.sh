#!/bin/ash
set -e

echo "-- Waiting for database ..."
while ! pg_isready -U ${DB_USER:-klaxon} -d postgres://${DB_HOST:-db}:5432/${DB_NAME:-klaxon} -t 1; do
    sleep 1s
done

echo "-- Running migrations ..."
mix ecto.migrate

echo "-- Starting!"
mix phx.server
