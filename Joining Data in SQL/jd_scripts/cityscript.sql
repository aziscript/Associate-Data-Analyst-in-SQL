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

-- Select country (aliased) from countries
SELECT 
   country_name  as country
FROM countries;

-- Select country and language names (aliased)
SELECT 
   c.country_name  AS country, 
   l.name AS language
-- From countries (aliased)
FROM countries AS c
-- Join to languages (aliased)
INNER JOIN languages AS l
-- Use code as the joining field with the USING keyword
USING(code);

-- Select country and language name (aliased)
SELECT c.country_name  AS country, l.name AS language
-- From countries (aliased)
FROM countries AS c
-- Join to languages (aliased)
INNER JOIN languages AS l
-- Use code as the joining field with the USING keyword
USING(code)
-- Filter for the Bhojpuri language
WHERE l.name = 'Bhojpuri';


-- What's the relationship between fertility and unemployment rates?
-- Select relevant fields
SELECT 
   c.country_name, 
   p.fertility_rate
FROM countries AS c
-- Inner join countries and populations, aliased, on code
INNER JOIN populations AS p
ON c.code = p.country_code;

-- Select fields
SELECT country_name, e.year, fertility_rate, e.unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
-- Join to economies (as e)
INNER JOIN economies AS e
-- Match on country code
USING(code);



SELECT country_name, e.year, fertility_rate, unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e
ON c.code = e.code
-- Add an additional joining condition such that you are also joining on year
	AND e.year = p.year;