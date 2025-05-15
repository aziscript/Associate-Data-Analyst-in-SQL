-- Select all columns from cities
SELECT *
FROM cities
LIMIT 10;

-- Select all columns from countries
SELECT *
FROM countries
LIMIT 10;

SELECT * 
FROM cities
-- Inner join to countries
INNER JOIN countries
-- Match on country codes
ON cities.country_code = countries.code;

-- Select name fields (with alias) and region 
SELECT 
   cities.name AS city, 
   countries.country_name  AS country, 
   region
FROM cities
INNER JOIN countries
ON cities.country_code = countries.code;



-- Select fields with aliases
SELECT 
   c.code AS country_code,
   c.country_name,
   e.year,
   e.inflation_rate
FROM countries AS c
-- Join to economies (alias e)
INNER JOIN economies AS e
-- Match on code field using table aliases
ON c.code = e.code;



SELECT 
   c.country_name AS country, 
   l.name AS language, 
   official
FROM countries AS c
INNER JOIN languages AS l
-- Match using the code column
USING(code);