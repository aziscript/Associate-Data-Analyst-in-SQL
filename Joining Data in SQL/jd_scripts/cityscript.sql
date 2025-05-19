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


SELECT 
    c1.name AS city,
    code,
    c2.country_name AS country,
    region,
    city_proper_pop
FROM cities AS c1
-- Perform an inner join with cities as c1 and countries as c2 on country code
INNER JOIN countries AS c2
ON c1.country_code = c2.code
ORDER BY code DESC;


SELECT 
	c1.name AS city, 
    code, 
    c2.country_name AS country,
    region, 
    city_proper_pop
FROM cities AS c1
-- Join right table (with alias)
LEFT JOIN countries AS c2
ON c1.country_code = c2.code
ORDER BY code DESC;

SELECT country_name ntry_name, region, gdp_percapita
FROM countries AS c
LEFT JOIN economies AS e
-- Match on code fields
USING(code)
-- Filter for the year 2010
WHERE year = 2010;


-- Select region, and average gdp_percapita as avg_gdp
SELECT region, AVG(gdp_percapita) AS avg_gdp
FROM countries AS c
LEFT JOIN economies AS e
USING(code)
WHERE year = 2010
-- Group by region
GROUP BY region;

SELECT region, AVG(gdp_percapita) AS avg_gdp
FROM countries AS c
LEFT JOIN economies AS e
USING(code)
WHERE year = 2010
GROUP BY region
-- Order by descending avg_gdp
ORDER BY avg_gdp DESC
-- Return only first 10 records
LIMIT 10;

SELECT region, AVG(gdp_percapita) AS avg_gdp
FROM economies AS e
RIGHT JOIN countries AS c
USING(code)
WHERE year = 2010
GROUP BY region
-- Order by descending avg_gdp
ORDER BY avg_gdp DESC
-- Return only first 10 records
LIMIT 10;

SELECT country_name AS country, code, region, basic_unit
FROM countries
-- Join to currencies
FULL JOIN currencies
USING (code)
-- Where region is North America or name is null
WHERE region = 'North America' OR country_name IS NULL
ORDER BY region;

SELECT country_name AS country, code, region, basic_unit
FROM countries
-- Join to currencies
LEFT JOIN currencies
USING (code)
WHERE region = 'North America' 
	OR country_name IS NULL
ORDER BY region;

SELECT country_name AS country, code, region, basic_unit
FROM countries
-- Join to currencies
INNER JOIN currencies
USING (code)
WHERE region = 'North America' 
	OR country_name IS NULL
ORDER BY region;



SELECT 
	c1.country_name AS country, 
    region, 
    l.name AS language,
	basic_unit, 
    frac_unit
FROM countries as c1 
-- Full join with languages (alias as l)
FULL JOIN languages AS l
USING(code)
-- Full join with currencies (alias as c2)
FULL JOIN currencies AS c2
USING(code)
WHERE region LIKE 'M%esia';


-- What are the languages presently spoken in the Pakistan and India?
SELECT c.country_name AS country, l.name AS language
-- Inner join countries as c with languages as l on code
FROM countries AS c
INNER JOIN languages as l
USING(code)
WHERE c.code IN ('PAK','IND')
	AND l.code in ('PAK','IND');


/*Given the shared history between 'PAK' and 'IND' countries, 
 * what languages could potentially have been spoken in either country 
 * over the course of their history?*/

SELECT c.country_name AS country, l.name AS language
FROM countries AS c        
-- Perform a cross join to languages (alias as l)
CROSS JOIN 	languages as l
WHERE c.code in ('PAK','IND')
	AND l.code in ('PAK','IND');


/*You will determine the names of the five countries and their 
 * respective regions with the lowest life expectancy for the year 2010.*/
SELECT 
	c.country_name AS country,
    region,
    life_expectancy AS life_exp
FROM countries AS c
-- Join to populations (alias as p) using an appropriate join
INNER JOIN populations as p
ON c.code = p.country_code
-- Filter for only results in the year 2010
WHERE year = 2010
-- Sort by life_exp
ORDER BY life_expectancy ASC
-- Limit to five records
LIMIT 5;



-- Select aliased fields from populations as p1
SELECT p1.country_code,
       p1.size AS size2010,
       p2.size AS size2015
FROM populations as P1
-- Join populations as p1 to itself, alias as p2, on country code
INNER JOIN populations as p2
USING(country_code);


SELECT 
	p1.country_code, 
    p1.size AS size2010, 
    p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
ON p1.country_code = p2.country_code
WHERE p1.year = p2.year - 5
-- Filter such that p1.year is always five years before p2.year
    AND p2.year = 2015;


SELECT 
    p1.country_code,
    p1.size AS size2010,
    p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
    USING (country_code)
WHERE p1.year = 2010 AND p2.year = 2015;



