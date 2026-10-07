-- Data behind the README charts.

-- Chart 1 and 2: mean vs median routes per served airport, top 15 countries.
SELECT country,
       COUNT(*)                   AS airports,
       ROUND(AVG(routes), 1)      AS mean_routes,
       median_agg(routes)         AS median_routes
FROM served_airports
GROUP BY country
ORDER BY airports DESC, country
LIMIT 15;

-- Chart 3: how many airports have how many routes (whole world).
SELECT CASE
         WHEN routes = 1    THEN '1'
         WHEN routes = 2    THEN '2'
         WHEN routes <= 5   THEN '3-5'
         WHEN routes <= 10  THEN '6-10'
         WHEN routes <= 20  THEN '11-20'
         WHEN routes <= 50  THEN '21-50'
         WHEN routes <= 100 THEN '51-100'
         ELSE '101+'
       END AS bucket,
       COUNT(*) AS airports
FROM served_airports
GROUP BY bucket
ORDER BY MIN(routes);

-- World totals for the text.
SELECT COUNT(*) AS airports, ROUND(AVG(routes), 1) AS mean_routes,
       median_agg(routes) AS median_routes, MAX(routes) AS max_routes
FROM served_airports;
