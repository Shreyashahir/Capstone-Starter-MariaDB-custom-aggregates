-- gini(x): Gini coefficient of x in each group, between 0 and 1.
--   0 = every row has the same value (perfectly even).
--   close to 1 = one row holds almost everything.
-- NULLs are ignored. Returns NULL for an empty group or when all values are 0.
-- Values are expected to be >= 0 (counts, sizes, amounts).
--
-- Formula, with the n values sorted ascending and i = 1..n:
--   G = 2 * SUM(i * x_i) / (n * SUM(x)) - (n + 1) / n
--
-- How it works: same pattern as median_agg. FETCH GROUP NEXT ROW collects the
-- group into a JSON array and keeps a running total. At the end of the group the
-- array is sorted with JSON_TABLE + ROW_NUMBER() and the formula is applied.

DELIMITER //

CREATE OR REPLACE AGGREGATE FUNCTION gini(x DOUBLE) RETURNS DOUBLE
BEGIN
  DECLARE vals JSON DEFAULT '[]';
  DECLARE n INT DEFAULT 0;
  DECLARE total DOUBLE DEFAULT 0;
  DECLARE result DOUBLE DEFAULT NULL;

  DECLARE CONTINUE HANDLER FOR NOT FOUND
  BEGIN
    IF n > 0 AND total > 0 THEN
      -- (n + 1) / n is done in DOUBLE: with two INTs MariaDB divides in DECIMAL
      -- and keeps only div_precision_increment (default 4) decimals.
      SELECT 2 * SUM(s.rn * s.v) / (n * total) - (n + 1) / CAST(n AS DOUBLE) INTO result
      FROM (
        SELECT jt.v, ROW_NUMBER() OVER (ORDER BY jt.v) AS rn
        FROM JSON_TABLE(vals, '$[*]' COLUMNS (v DOUBLE PATH '$')) AS jt
      ) AS s;
    END IF;
    RETURN result;
  END;

  LOOP
    FETCH GROUP NEXT ROW;
    IF x IS NOT NULL THEN
      SET vals = JSON_ARRAY_APPEND(vals, '$', x);
      SET n = n + 1;
      SET total = total + x;
    END IF;
  END LOOP;
END //

DELIMITER ;
