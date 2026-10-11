-- median_agg(x): the middle value of x in each group.
-- With an even number of rows it returns the mean of the two middle values.
-- NULLs are ignored. Returns NULL for an empty group.
--
-- Named median_agg because MariaDB already has a built-in MEDIAN() window function.
--
-- How it works: FETCH GROUP NEXT ROW walks the rows of the group. Each value is
-- added to a comma-separated text list. When the group ends (NOT FOUND), the list
-- is read once as a JSON array with JSON_TABLE, sorted, and the middle row(s) are
-- picked.
--
-- Why a text list and not JSON_ARRAY_APPEND: the first version appended to a JSON
-- array. That parses and copies the whole array on every row, so a group of
-- 10,000 rows took about 10 s. The text list takes under 1 s for the same group
-- (see experiments/05_faster_median.sql and results/04_scale.txt).

DELIMITER //

CREATE OR REPLACE AGGREGATE FUNCTION median_agg(x DOUBLE) RETURNS DOUBLE
BEGIN
  DECLARE vals LONGTEXT DEFAULT '';
  DECLARE n INT DEFAULT 0;
  DECLARE result DOUBLE DEFAULT NULL;
  DECLARE take INT;
  DECLARE skip INT;

  DECLARE CONTINUE HANDLER FOR NOT FOUND
  BEGIN
    IF n > 0 THEN
      -- odd n: take 1 row; even n: take the 2 middle rows
      SET take = 2 - n % 2;
      SET skip = (n - 1) DIV 2;
      SELECT AVG(v) INTO result
      FROM (
        SELECT jt.v
        FROM JSON_TABLE(CONCAT('[', vals, ']'), '$[*]' COLUMNS (v DOUBLE PATH '$')) AS jt
        ORDER BY jt.v
        LIMIT take OFFSET skip
      ) AS middle;
    END IF;
    RETURN result;
  END;

  LOOP
    FETCH GROUP NEXT ROW;
    IF x IS NOT NULL THEN
      SET vals = IF(n = 0, CAST(x AS CHAR), CONCAT(vals, ',', x));
      SET n = n + 1;
    END IF;
  END LOOP;
END //

DELIMITER ;
