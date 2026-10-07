-- median_agg(x): the middle value of x in each group.
-- With an even number of rows it returns the mean of the two middle values.
-- NULLs are ignored. Returns NULL for an empty group.
--
-- Named median_agg because MariaDB already has a built-in MEDIAN() window function.
--
-- How it works: FETCH GROUP NEXT ROW walks the rows of the group. Each value is
-- appended to a JSON array. When the group ends (NOT FOUND), the array is turned
-- back into rows with JSON_TABLE, sorted, and the middle row(s) are picked.

DELIMITER //

CREATE OR REPLACE AGGREGATE FUNCTION median_agg(x DOUBLE) RETURNS DOUBLE
BEGIN
  DECLARE vals JSON DEFAULT '[]';
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
        FROM JSON_TABLE(vals, '$[*]' COLUMNS (v DOUBLE PATH '$')) AS jt
        ORDER BY jt.v
        LIMIT take OFFSET skip
      ) AS middle;
    END IF;
    RETURN result;
  END;

  LOOP
    FETCH GROUP NEXT ROW;
    IF x IS NOT NULL THEN
      SET vals = JSON_ARRAY_APPEND(vals, '$', x);
      SET n = n + 1;
    END IF;
  END LOOP;
END //

DELIMITER ;
