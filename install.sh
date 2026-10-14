#!/bin/sh
# Installs the served_airports view and the median_agg, gini, mode_agg and
# wpercentile functions into the openflights database (flightdb2).
# The default password comes from the openflights compose file (local use only).
# Use another one with: DBPW=yourpw ./install.sh
set -e
DBPW="${DBPW:-flightpw}"
CONTAINER="${CONTAINER:-openflights-mariadb}"

cat sql/*.sql | docker exec -i "$CONTAINER" mariadb -uroot -p"$DBPW" flightdb2
echo "Installed: served_airports, median_agg, gini, mode_agg, wpercentile"
