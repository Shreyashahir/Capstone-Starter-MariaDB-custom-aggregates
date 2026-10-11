-- mode_agg(x): the most common value of x in each group. Works on text and numbers.
-- Ties: the smallest value wins (alphabetical, in the connection's collation),
-- so the result is the same every time.
-- NULLs are ignored. Returns NULL for an empty group.
-- Numbers are compared as text, so for ties '10' comes before '9'.
-- Text is compared with the default collation (utf8mb4_uca1400_ai_ci on
-- openflights), which ignores case and accents: 'Lufthansa' and 'LUFTHANSA'
-- count as the same value.
--
-- How it works: same pattern as median_agg. Each value is wrapped with
-- JSON_QUOTE (so commas and quotes inside a value are safe) and added to a
-- text list. At the end of the group the list is read once with JSON_TABLE,
-- grouped, and the value with the highest count is picked.

DELIMITER //

CREATE OR REPLACE AGGREGATE FUNCTION mode_agg(x VARCHAR(255)) RETURNS VARCHAR(255)
BEGIN
  DECLARE vals LONGTEXT DEFAULT '';
  DECLARE n INT DEFAULT 0;
  DECLARE result VARCHAR(255) DEFAULT NULL;

  DECLARE CONTINUE HANDLER FOR NOT FOUND
  BEGIN
    IF n > 0 THEN
      SELECT jt.v INTO result
      FROM JSON_TABLE(CONCAT('[', vals, ']'), '$[*]' COLUMNS (v VARCHAR(255) PATH '$')) AS jt
      GROUP BY jt.v
      ORDER BY COUNT(*) DESC, jt.v
      LIMIT 1;
    END IF;
    RETURN result;
  END;

  LOOP
    FETCH GROUP NEXT ROW;
    IF x IS NOT NULL THEN
      SET vals = IF(n = 0, JSON_QUOTE(x), CONCAT(vals, ',', JSON_QUOTE(x)));
      SET n = n + 1;
    END IF;
  END LOOP;
END //

DELIMITER ;
