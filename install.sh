#!/bin/sh
# Installs the served_airports view and the median_agg and gini functions
# into the openflights database.
# The password is the one from the openflights compose file (local use only).
# Change it here, or run: DBPW=yourpw ./install.sh
set -e
DBPW="${DBPW:-flightpw}"
CONTAINER="${CONTAINER:-openflights-mariadb}"

cat sql/*.sql | docker exec -i "$CONTAINER" mariadb -uroot -p"$DBPW" flightdb2
echo "Installed: served_airports, median_agg, gini"
