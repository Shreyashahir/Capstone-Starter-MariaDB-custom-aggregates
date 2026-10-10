# Prompt 004: gini aggregate

- Date: 2026-10-10, 23:43 (Morocco)
- Tool: Claude (Anthropic)

## Prompt
> on the thusday 15 ihave to be completed the starter
> the teacher sayes that what we did it noooooot enouph
> ...
> we have to finish the starter properly

## Output
- `sql/03_gini.sql`: `gini` with CREATE AGGREGATE FUNCTION.
- `queries/gini_before.sql`, `queries/gini_after.sql`, `queries/gini_check.sql`.
- README: Gini finding, chart 4, before/after row, "A trap found on the way".
- Tests: `gini_check.sql` 0 rows. Edge cases: (1,1,1) -> 0, (0,0,0,10) -> 0.75, (NULL) -> NULL, (0) -> NULL, (5) -> 0.
