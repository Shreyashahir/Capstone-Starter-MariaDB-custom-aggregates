-- Edge-case tests for median_agg and gini.
-- Each row is one test: pass = 1 means the result is what we expect.
-- Run with ./test.sh (it fails if any row has pass = 0).
-- Numbers count as equal when they differ by less than 1e-12 of their size
-- (two correct DOUBLE averages can differ in the last digit).

SELECT test, got, expected,
       IF((got <=> expected) OR ABS(got - expected) <= 1e-12 * GREATEST(1, ABS(expected)), 1, 0) AS pass
FROM (
  SELECT 'median: odd count'       AS test, (SELECT median_agg(v) FROM (SELECT 1 AS v UNION ALL SELECT 3 UNION ALL SELECT 2) t) AS got, 2 AS expected
  UNION ALL SELECT 'median: even count',    (SELECT median_agg(v) FROM (SELECT 1 AS v UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) t), 2.5
  UNION ALL SELECT 'median: single value',  (SELECT median_agg(v) FROM (SELECT 7 AS v) t), 7
  UNION ALL SELECT 'median: negatives',     (SELECT median_agg(v) FROM (SELECT -5 AS v UNION ALL SELECT -1 UNION ALL SELECT -3) t), -3
  UNION ALL SELECT 'median: decimals',      (SELECT median_agg(v) FROM (SELECT 1.5 AS v UNION ALL SELECT 2.5) t), 2
  UNION ALL SELECT 'median: NULL ignored',  (SELECT median_agg(v) FROM (SELECT 5 AS v UNION ALL SELECT NULL UNION ALL SELECT 1) t), 3
  UNION ALL SELECT 'median: only NULLs',    (SELECT median_agg(v) FROM (SELECT NULL AS v UNION ALL SELECT NULL) t), NULL
  UNION ALL SELECT 'median: empty group',   (SELECT median_agg(v) FROM (SELECT 1 AS v FROM DUAL WHERE 0) t), NULL
  UNION ALL SELECT 'median: 2000 random doubles vs MEDIAN()',
            (SELECT median_agg(v) FROM (SELECT RAND(seq) * 1e6 AS v FROM seq_1_to_2000) t),
            (SELECT MEDIAN(v) OVER () FROM (SELECT RAND(seq) * 1e6 AS v FROM seq_1_to_2000) t LIMIT 1)
  UNION ALL SELECT 'median: ROLLUP total (Germany + Morocco)',
            (SELECT m FROM (SELECT country, median_agg(routes) AS m FROM served_airports
                            WHERE country IN ('Germany', 'Morocco') GROUP BY country WITH ROLLUP) r
             WHERE country IS NULL), 18
  UNION ALL SELECT 'gini: all equal',       (SELECT gini(v) FROM (SELECT 4 AS v UNION ALL SELECT 4 UNION ALL SELECT 4) t), 0
  UNION ALL SELECT 'gini: one holds all',   (SELECT gini(v) FROM (SELECT 0 AS v UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 10) t), 0.75
  UNION ALL SELECT 'gini: 1..5 = 4/15',     (SELECT gini(v) FROM (SELECT seq AS v FROM seq_1_to_5) t), 4 / CAST(15 AS DOUBLE)
  UNION ALL SELECT 'gini: all zero',        (SELECT gini(v) FROM (SELECT 0 AS v UNION ALL SELECT 0) t), NULL
  UNION ALL SELECT 'gini: NULL ignored',    (SELECT gini(v) FROM (SELECT 4 AS v UNION ALL SELECT NULL UNION ALL SELECT 4) t), 0
  UNION ALL SELECT 'gini: empty group',     (SELECT gini(v) FROM (SELECT 1 AS v FROM DUAL WHERE 0) t), NULL
  UNION ALL SELECT 'both in one SELECT (US)',
            (SELECT ROUND(median_agg(routes) + gini(routes), 6) FROM served_airports WHERE country = 'United States'),
            ROUND(3 + 0.8153623872310896, 6)
) AS cases;
