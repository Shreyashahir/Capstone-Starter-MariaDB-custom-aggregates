# Prompt 002: first working piece (median)

- Date: 2026-10-07, 13:49 (Morocco)
- Tool: Claude (Anthropic)

## Prompt
> go with option A
> use colima it already instaled my macbook doesn't suport nor homebrew nor docker disktop any more

## Output
- `sql/01_served_airports.sql`: view with routes per served airport.
- `sql/02_median_agg.sql`: `median_agg` with CREATE AGGREGATE FUNCTION.
- `queries/median_before.sql`, `queries/median_after.sql`, `queries/median_check.sql`.
- `README.md` first draft.
- Test run: `median_check.sql` returned 0 rows (custom = built-in for all countries). Edge cases: (1,3,2,10) -> 2.5, (5,NULL,1) -> 3, (NULL) -> NULL.
