
-- Comparing global economies
-- UNION does not return duplicates
-- Select all fields from economies2015
SELECT *
FROM economies2015   
-- Set operation
UNION
-- Select all fields from economies2019
SELECT *
FROM economies2019
ORDER BY code, year;


-- Query that determines all pairs of code and year from economies and populations, without duplicates
SELECT code, year
FROM economies
UNION
SELECT country_code AS code, year
FROM populations
ORDER BY code, year;

-- UNION ALL returns duplicates
SELECT code, year
FROM economies
-- Set theory clause
UNION ALL
SELECT country_code AS code, year
FROM populations
ORDER BY code, year;


-- Countries that share names with cities.
-- Return all cities with the same name as a country
-- Find the names of cities with the same names as countries
SELECT name
FROM cities
INTERSECT
SELECT country_name
FROM countries;


-- Return all cities that do not have the same name as a country
SELECT name
FROM cities 
EXCEPT
SELECT country_name AS name
FROM countries
ORDER BY name;

