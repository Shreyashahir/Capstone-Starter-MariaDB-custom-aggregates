A project for area 2, "Custom aggregate functions in SQL" for the [MariaDB student database projects, 2026-09](https://mariadb.org/bachelor_hackathon_2026-09/).

# Custom aggregate functions in MariaDB

MariaDB lets you write your own aggregate function in SQL with `CREATE AGGREGATE FUNCTION` and `FETCH GROUP NEXT ROW`. MySQL has no SQL-level equivalent: there you write a C UDF or do without.

This repo builds two aggregates and uses them on the [openflights](https://github.com/mariadb/openflights) data:

| Function | Status | Question it answers |
|---|---|---|
| `median_agg(x)` | working | What is the typical number of routes per airport in a country? |
| `gini(x)` | planned | How concentrated are a country's routes in a few airports? |

Each one is shown next to the query you would write without it.

## Status

Work in progress. Findings and measurements come later.

## Requirements

- Docker with Compose (tested with Colima on an Intel Mac)
- MariaDB 12.3.3 (image `mariadb:lts` from the openflights compose file, checked with `SELECT VERSION();`)

## Setup

1. Start MariaDB with the openflights data:

   ```sh
   git clone https://github.com/mariadb/openflights.git
   cd openflights
   docker compose up --wait
   cd ..
   ```

2. Install the view and the functions (one step):

   ```sh
   cat sql/*.sql | docker exec -i openflights-mariadb mariadb -uroot -pflightpw flightdb2
   ```

3. Run a query:

   ```sh
   docker exec -i openflights-mariadb mariadb -uroot -pflightpw flightdb2 < queries/median_after.sql
   ```

The password `flightpw` comes from the openflights compose file and is for local use only.

## Data model

| Object | What it is |
|---|---|
| `airports`, `routes` | openflights tables, unchanged |
| `served_airports` (view) | one row per airport with at least one departing route: `apid`, `name`, `country`, `routes` |

Airports with no routes are left out. Most of them are small airfields, and including them as zeros would hide the shape of real traffic.

## Before and after

| Query | Without the custom aggregate | With it |
|---|---|---|
| Median routes per airport, per country | [queries/median_before.sql](queries/median_before.sql) | [queries/median_after.sql](queries/median_after.sql) |

[queries/median_check.sql](queries/median_check.sql) checks that both give the same numbers.

## How it was made

- Made by Ayoub Labrinssi.
- AI use is recorded in [ai-log/AI-use log.md](ai-log/AI-use%20log.md).
