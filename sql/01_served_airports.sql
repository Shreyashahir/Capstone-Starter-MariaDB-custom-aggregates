-- Data model: one row per airport that has at least one departing route.
-- routes = number of routes leaving that airport (openflights routes table).
CREATE OR REPLACE VIEW served_airports AS
SELECT a.apid,
       a.name,
       a.country,
       COUNT(*) AS routes
FROM routes r
JOIN airports a ON a.apid = r.src_apid
GROUP BY a.apid, a.name, a.country;
