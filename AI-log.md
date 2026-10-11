# AI log

I used Claude (Anthropic) as a helper on this starter. This file lists every use: what I asked for, what the AI made, and what I decided or checked myself. Prompts are copied with spelling and grammar fixed. The meaning is the same, and long ones are shortened with "...".

When the code changes, this log is updated so it still matches. New entries go at the bottom.

## My part

- I chose the topic and the plan: option A of the three starters (median and Gini aggregates on openflights).
- I set up the database on my Mac with Colima, because my Mac no longer supports Docker Desktop.
- I decided what to work on at each step, based on the supervisor's feedback and the MariaDB evaluation criteria.
- I approved each new piece before it was added: Gini, the depth experiments, `mode_agg` and the MIT license.
- I chose opensource.guide as the standard for how the repo is organized.
- Every change goes through a branch and a pull request, which I merge on GitHub.
- I prepared the meeting presentation with the material from entry 7.

## What the AI did

- Wrote first versions of the SQL functions, queries, tests, scripts and README text.
- Ran the experiments and timings on my local database and saved the results in `results/`.
- Searched MariaDB JIRA for the known bugs behind each limit.
- Cleaned up the code and added the open source files (entry 9).

## Summary

| # | Date | I asked for | AI made | What I decided or checked |
|---|---|---|---|---|
| 1 | 7 Oct | A starter I can do alone, based on the course files | 3 starter options and a step plan | Picked option A: median and Gini on openflights |
| 2 | 7 Oct | The first working piece, using Colima | `served_airports` view, `median_agg`, before/after/check queries, first README | Chose Colima for the database. The check query gives the same median as MariaDB's `MEDIAN()` for every country |
| 3 | 7 Oct | Charts in the README that explain the results | Chart query, 3 Mermaid charts, findings text | Kept the charts. Merged in PR #1 |
| 4 | 10 Oct | More depth, after the supervisor said the work was not enough | `gini` aggregate, hand-written version, check query. Found the INT/INT DECIMAL rounding trap | Added Gini, the second half of my plan. Merged in PR #1 |
| 5 | 10-11 Oct | Fix the gaps the MariaDB evaluation criteria showed | Experiments against the docs example and SQL features, 10-run timings, faster storage (about 17x at 10,000 rows), tests, `install.sh`, `test.sh` | Merged PR #1 first, then chose to work on depth. Branch `feat/limits` |
| 6 | 11 Oct | What was still missing before the meeting | `mode_agg` for text, 10 tests, timing, `LICENSE`, `CONTRIBUTING.md` | Approved `mode_agg` and the MIT license. Branch `feat/mode-agg` |
| 7 | 11 Oct | Animated material to present the work at the meeting | An animated page in English, an Arabic version for my own study and meeting notes (all outside the repo) | Used them to prepare and rehearse the talk |
| 8 | 11 Oct | A cleaner AI log in one file | This file, with my decisions in their own column | Checked that every line is true |
| 9 | 11 Oct | Clean, easy-to-read code, and a repo that follows opensource.guide | Shorter functions and comments, clearer `test.sh` output, tidier experiment headers, code of conduct, issue and PR templates, fuller CONTRIBUTING | Chose opensource.guide as the standard. Same results: 27 tests and 3 checks pass, same speed. Branch `refactor/clean-code` |

## Prompts

### 1. Starter choice

- Date: 2026-10-07, 13:45 (Morocco)
- Input files: Team Guide.pdf, Week 02 To-do.pdf, MariaDB project areas 2026-09.pdf, MariaDB Q&A 2026-09.pdf, mariadb.org/bachelor_hackathon_2026-09, github.com/mariadb/openflights

> We're going to work on the Capstone project. Read the course files and the MariaDB project areas, and suggest a starter I can do on my own. I'm working alone for now, so leave out the team instructions. Give me the steps and keep an AI log, as the to-do file asks.

Output:
- `Starter plan.md` (outside the repo): 3 options, option A recommended (median and Gini custom aggregates on openflights), 8 steps.
- The first entry of this log.

### 2. First working piece (median)

- Date: 2026-10-07, 13:49 (Morocco)

> Go with option A. Use Colima, it's already installed. My MacBook doesn't support Homebrew or Docker Desktop anymore.

Output:
- `sql/01_served_airports.sql`: view with routes per served airport.
- `sql/02_median_agg.sql`: `median_agg` with `CREATE AGGREGATE FUNCTION`.
- `queries/median_before.sql`, `queries/median_after.sql`, `queries/median_check.sql`.
- First draft of `README.md`.
- Test run: `median_check.sql` returned 0 rows (custom = built-in for all countries). Edge cases: (1, 3, 2, 10) gives 2.5, (5, NULL, 1) gives 3, (NULL) gives NULL.

### 3. README charts

- Date: 2026-10-07, 14:02 (Morocco)

> Okay, good. Make sure the README has some graphs that explain the data results.

Output:
- `queries/chart_data.sql`: the queries behind every chart.
- README: "Findings so far" and 3 Mermaid charts (median per country, mean vs median, airports by route count).

### 4. Gini aggregate

- Date: 2026-10-10, 23:43 (Morocco)

> The starter has to be complete by Thursday the 15th. The teacher says what we did is not enough. ... We have to finish the starter properly.

Output:
- `sql/03_gini.sql`: `gini` with `CREATE AGGREGATE FUNCTION`.
- `queries/gini_before.sql`, `queries/gini_after.sql`, `queries/gini_check.sql`.
- README: Gini finding, chart 4, before/after row, "A trap found on the way".
- Tests: `gini_check.sql` returned 0 rows. Edge cases: (1, 1, 1) gives 0, (0, 0, 0, 10) gives 0.75, (NULL) gives NULL, (0) gives NULL, (5) gives 0.

### 5. Limits, scale test, tests

- Date: 2026-10-10 and 2026-10-11 (Morocco)

> (Pasted the MariaDB project evaluation prompt.)
>
> Merged. Start on them now.

"Them" means the depth items from the evaluation: compare with the median example in the docs, test OVER, DISTINCT and large groups, timings with spread, a "when not to use" section, a tests file, an install script, the password in one variable.

Output:
- `experiments/01_docs_median.sql`: the docs' temp-table median next to ours.
- `experiments/02_limits.sql`: OVER, DISTINCT, HAVING, ROLLUP, empty set, text input.
- `experiments/03_view_subquery.sql`: aggregates in a view and in a correlated subquery.
- `experiments/04_scale.sql`: 10-run timing on groups of 100 to 20,000 rows.
- `experiments/05_faster_median.sql`: the first JSON version kept as `median_json`.
- `results/`: the output of each experiment.
- `sql/02_median_agg.sql`, `sql/03_gini.sql`: a text list instead of `JSON_ARRAY_APPEND` (same results, faster).
- `tests/tests.sql`, `test.sh`, `install.sh`.
- README: "Limits found", "Speed", "When not to use a custom aggregate".
- JIRA issues found by searching jira.mariadb.org for each limit.

### 6. mode_agg, license, contributing

- Date: 2026-10-11 (Morocco)

> What should I add to the starter, what is still missing, and what am I going to present at the next meeting?

(Claude listed what was missing and suggested `mode_agg` and an MIT license.)

> Yes, add what's needed and prepare what to present.

Output:
- `sql/04_mode_agg.sql`: `mode_agg`, the most common value, works on text. Ties go to the smallest value.
- `queries/mode_before.sql`, `queries/mode_after.sql`, `queries/mode_check.sql` (0 rows: same airline for all 225 countries).
- `tests/tests.sql`: 10 mode tests (ties, commas and quotes, Arabic text, case, NULL, empty).
- `experiments/06_mode_timing.sql` and `results/06_mode_timing.txt`: 5.2 s vs 0.44 s for the hand-written query.
- README: mode finding, before/after row, "Try it on your own table", license section.
- `LICENSE` (MIT), `CONTRIBUTING.md`.
- Meeting notes (outside the repo).

### 7. Presentation material

- Date: 2026-10-11 (Morocco)

> For the meeting, make me an animated page that shows what we have done, with the data and the technical side as easy animations that explain what the code does.

(Then asked for the same in Arabic, to go through the code in my own language.)

Output:
- An animated page in English: mean vs median, how `median_agg` runs row by row, Gini, mode, limits, speed, tests.
- An Arabic version for my own study, with a step-by-step run on the Moroccan airports.
- Both are outside the repo. They are presentation and study material, not part of the product.

### 8. AI log in one file

- Date: 2026-10-11 (Morocco)

Summary of the request: check the AI log, make it cleaner and easier to read, and keep all past and future prompts in one file.

Output:
- This file. It replaces `ai-log/AI-use log.md` and the 6 files in `ai-log/prompts/` (still in the git history).
- README and CONTRIBUTING now point here.

### 9. Clean code and open source practices

- Date: 2026-10-11 (Morocco)

> Now clean the code of anything unneeded. Make it clean code that is easy to follow, read and debug, and to the point.
>
> Make sure that our code respects https://opensource.guide.

Output:
- `sql/02` to `sql/04`: shorter header comments, a comment on each variable, the handler returns its result directly, the comma rule written once (`IF(n = 0, '', ',')`). Same logic and results.
- `test.sh`: runs the tests once instead of twice, prints one line per test, and shows got and expected for a failing test.
- `experiments/`: the same Run line format in every file; the summary query in `04_scale.sql` is no longer commented out.
- From the opensource.guide checklist: `CODE_OF_CONDUCT.md` (Contributor Covenant 2.1), issue templates for bugs and features, a pull request template, a fuller `CONTRIBUTING.md` (what help is wanted, how to suggest a feature, how to run the tests, where to ask), and a status and help section in the README.
- Checked: `./test.sh` passes (27 tests, 3 checks), `experiments/05` checks give 0 differences, timing at 10,000 rows is the same (about 0.6 s).

## Adding a new entry

1. Add a row to the Summary table.
2. Add a section under Prompts with the date, the prompt and the output.
3. Commit it together with the change the AI helped with.
