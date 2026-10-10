# AI-use log

One line per AI use: the tool, the part it touched, the prompt, and what it produced.
Prompts are saved in `prompts/`. When the code changes, update this log so it still matches.

| # | Date | Tool | Part it touched | Prompt | What it produced | What I did with it |
|---|---|---|---|---|---|---|
| 1 | 2026-10-07 | Claude (Anthropic) | Starter choice and plan (no code) | [prompts/001-starter-choice.md](prompts/001-starter-choice.md) | Summary of the course files and project areas, 3 starter options, step plan (`Starter plan.md`, kept outside the repo) | Picked option A |
| 2 | 2026-10-07 | Claude (Anthropic) | `sql/01_served_airports.sql`, `sql/02_median_agg.sql`, `queries/median_*.sql`, `README.md` | [prompts/002-median-first-piece.md](prompts/002-median-first-piece.md) | View, `median_agg` function, before/after/check queries, README draft. Tested on MariaDB 12.3.3: same result as built-in MEDIAN() for every country | Reviewing |
| 3 | 2026-10-07 | Claude (Anthropic) | `queries/chart_data.sql`, README "Findings so far" and 3 Mermaid charts | [prompts/003-readme-charts.md](prompts/003-readme-charts.md) | Chart query, findings text, charts with numbers from MariaDB 12.3.3 | Reviewing |
| 4 | 2026-10-10 | Claude (Anthropic) | `sql/03_gini.sql`, `queries/gini_*.sql`, README (Gini chart, before/after, DECIMAL trap) | [prompts/004-gini.md](prompts/004-gini.md) | `gini` aggregate, hand-written version, check query. Found and fixed the INT/INT DECIMAL rounding trap. Tested on MariaDB 12.3.3: 0 differences for all countries | Reviewing |
