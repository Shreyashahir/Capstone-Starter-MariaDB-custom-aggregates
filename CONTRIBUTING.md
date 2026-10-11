# Contributing

## Report a problem
Open an issue with:
- the query you ran,
- what you got and what you expected,
- your MariaDB version (`SELECT VERSION();`).

## Change something
1. Open an issue first so we can agree on the change.
2. Make a branch from `main`, e.g. `feat/percentile-agg` or `fix/mode-ties`.
3. Run `./install.sh` and `./test.sh`. All tests must pass.
4. Open a pull request that links the issue.

## Add a new aggregate
- Put it in `sql/` with the next number, e.g. `sql/05_percentile_agg.sql`.
- Start the file with a comment: what it returns, how NULLs, empty groups and ties are handled.
- Add a before/after/check query in `queries/` like the existing ones.
- Add edge cases to `tests/tests.sql`.
- Add a row to the function table in the README.

## AI use
If you use an AI tool, add a line to `ai-log/AI-use log.md` and save the prompt in `ai-log/prompts/`.
