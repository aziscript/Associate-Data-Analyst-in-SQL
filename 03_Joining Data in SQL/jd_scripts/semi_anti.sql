--  Identifying languages spoken in the Middle East

-- Select country code for countries in the Middle East
SELECT code
FROM countries
WHERE region = 'Middle East';

-- Select unique language names
SELECT DISTINCT(name)
FROM languages
-- Order by the name of the language
ORDER BY name;

-- Semi-join
SELECT DISTINCT name
FROM languages
-- Add syntax to use bracketed subquery below as a filter
WHERE code IN
    (SELECT code
    FROM countries
    WHERE region = 'Middle East')
ORDER BY name;



-- Identifying currencies of Oceanian countries.
-- Select code and name of countries from Oceania
SELECT code, country_name 
FROM countries
WHERE continent = 'Oceania';

SELECT c1.code, country_name, basic_unit AS currency
FROM countries AS c1
INNER JOIN currencies AS c2
ON c1.code = c2.code
WHERE c1.continent = 'Oceania';

-- Anti-join
SELECT code, country_name
FROM countries
WHERE continent = 'Oceania'
-- Filter for countries not included in the bracketed subquery
  AND code NOT IN
    (SELECT code
    FROM currencies);


-- Subquery inside WHERE
-- Which countries had high average life expectancies in 2015?
-- Select average life_expectancy from the populations table
SELECT AVG(life_expectancy)
FROM populations
-- Filter for the year 2015
WHERE year = 2015;

SELECT *
FROM populations
WHERE year = 2015
-- Filter for only those populations where life expectancy is 1.15 times higher than average
  AND life_expectancy > 1.15 *
  (SELECT AVG(life_expectancy)
   FROM populations
   WHERE year = 2015);


-- Identify capital cities in order of largest to smallest population
SELECT country_name, capital
FROM countries
WHERE capital IN ('Beijing', 'Dhaka', 'Tokyo', 'Moscow', 'Caira');

SELECT name, urbanarea_pop
FROM cities
WHERE name IN ('Beijing', 'Dhaka', 'Tokyo', 'Moscow', 'Caira');

-- Select relevant fields from cities table
SELECT name, country_code, urbanarea_pop
FROM cities
-- Filter using a subquery on the countries table
WHERE name IN 
   (SELECT capital
   FROM countries)
ORDER BY urbanarea_pop DESC;


-- Subquery inside SELECT
-- Find top nine countries with the most cities
SELECT countries.country_name AS country, 
    COUNT(cities.name) AS cities_num
FROM countries
LEFT JOIN cities
ON countries.code = cities.country_code
GROUP BY countries.country_name
-- Order by count of cities as cities_num
ORDER BY  cities_num DESC, 
    country ASC
-- Limit the results
LIMIT 9;


-- Subquery inside SELECT
-- For every country in the countries table:
-- “Run a mini query on the cities table — count how many cities belong to this country.”
SELECT countries.country_name AS country,
-- Subquery that provides the count of cities   
  (SELECT COUNT(cities.name)
   FROM cities
   WHERE cities.country_code = countries.code) AS cities_num
FROM countries
ORDER BY cities_num DESC, country
LIMIT 9;





-- Subquery inside FROM
-- What's the number of languages spoken for each country?
-- Select code, and language count as lang_num
SELECT code, COUNT(*) AS lang_num
FROM languages
GROUP BY code;

-- Select local_name and lang_num from appropriate tables
SELECT local_name, sub.lang_num
FROM countries,
    (SELECT code, COUNT(*) AS lang_num
     FROM languages
     GROUP BY code) AS sub
-- Where codes match    
WHERE countries.code = sub.code
ORDER BY lang_num DESC;




-- Find inflation and unemployment rate for certain countries in 2015 
-- With "Republic" or "Monarchy" as their form of government.
SELECT code, gov_form 
FROM countries
WHERE gov_form LIKE '%Republic%' 
   OR gov_form LIKE '%Monarchy%';

SELECT code, 
       inflation_rate, 
       unemployment_rate
FROM economies 
WHERE "year" = 2015;


-- Select relevant fields
SELECT code, 
       inflation_rate, 
       unemployment_rate
FROM economies 
WHERE year = 2015
   AND code IN 
-- Subquery returning country codes filtered on gov_form
	  (SELECT code
    FROM countries
    WHERE gov_form LIKE '%Republic' 
        OR gov_form LIKE 'Monarchy')
ORDER BY inflation_rate;


-- The top 10 capital cities in Europe and the Americas by city_perc
-- city_perc = city_proper_pop / metroarea_pop * 100
-- Select fields from cities
SELECT name, 
       country_code, 
       city_proper_pop, 
       metroarea_pop,
       city_proper_pop / metroarea_pop * 100 AS city_perc
FROM cities
WHERE name IN
-- Use subquery to filter city name
    (SELECT capital
    FROM countries
    WHERE continent LIKE 'Europe' 
        OR continent LIKE '%America')
-- Add filter condition such that metroarea_pop does not have null values
AND metroarea_pop IS NOT NULL
-- Sort and limit the result
ORDER BY city_perc DESC
LIMIT 10;


