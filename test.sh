#!/bin/sh
# Runs the edge-case tests and the two check queries.
# Exits with an error if any test fails. Run ./install.sh first.
DBPW="${DBPW:-flightpw}"
CONTAINER="${CONTAINER:-openflights-mariadb}"
db() { docker exec -i "$CONTAINER" mariadb -uroot -p"$DBPW" flightdb2 "$@"; }

db -t < tests/tests.sql || exit 1
failed=$(db -N < tests/tests.sql | awk -F'\t' '$NF != 1' | wc -l | tr -d ' ')

for check in queries/median_check.sql queries/gini_check.sql queries/mode_check.sql; do
  rows=$(db -N < "$check" | wc -l | tr -d ' ')
  echo "$check: $rows countries differ (expect 0)"
  [ "$rows" = 0 ] || failed=$((failed + 1))
done

if [ "$failed" = 0 ]; then
  echo "All tests passed."
else
  echo "$failed test(s) failed."
  exit 1
fi
