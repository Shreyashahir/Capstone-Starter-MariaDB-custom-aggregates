# Prompt 005: limits, scale test, tests

- Date: 2026-10-10 and 2026-10-11 (Morocco)
- Tool: Claude (Anthropic)

## Prompt
> (pasted the MariaDB project evaluation prompt, then)
> merged start on them now

"Them" = the depth items from the evaluation: compare with the docs' median
example, test OVER / DISTINCT / large groups, timings with spread, a "when not
to use" section, a tests file, an install script, the password in one variable.

## Output
- `experiments/01_docs_median.sql`: the docs' temp-table median next to ours.
- `experiments/02_limits.sql`: OVER, DISTINCT, HAVING, ROLLUP, empty set, text input.
- `experiments/03_view_subquery.sql`: aggregates in a view and in a correlated subquery.
- `experiments/04_scale.sql`: 10-run timing on groups of 100 to 20,000 rows.
- `experiments/05_faster_median.sql`: the first JSON version kept as `median_json`.
- `results/`: the output of each experiment.
- `sql/02_median_agg.sql`, `sql/03_gini.sql`: text list instead of JSON_ARRAY_APPEND (same results, faster).
- `tests/tests.sql`, `test.sh`, `install.sh`.
- README: "Limits found", "Speed", "When not to use a custom aggregate".
- JIRA issues found by searching jira.mariadb.org for each limit.
