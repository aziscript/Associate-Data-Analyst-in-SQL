-- Semi join
-- Identify languages spoken in the Middle East.
/*The languages table contains information about languages and countries, 
but it does not tell you what region the countries belong to. 
You can build up a semi join by filtering the countries table by a particular region, 
and then using this to further filter the languages table*/

-- Break the problem down
-- Select country code for countries in the Middle East
SELECT code 
FROM countries c 
WHERE region = 'Middle East';

-- Select unique language names
SELECT DISTINCT(name)
FROM languages l 
ORDER BY name;

-- Now let's reate a semi join out of the two queries we've written above
-- Which filters unique languages returned in the first query 
-- for only those languages spoken in the 'Middle East'

SELECT DISTINCT(name) AS unique_lang
FROM languages l 
WHERE code IN     --  The query is filtering languages by country codes that in Middle East.
   (SELECT code
   FROM countries c
   WHERE region = 'Middle East')
ORDER BY name;




-- identify currencies of Oceanian countries.
-- countries table has country code and continent('Oceania')
-- currencies table country code and basic unit and curr_code
-- Let's break it down

-- Filter countries in 'Oceania' continent
SELECT code
FROM countries c 
WHERE continent = 'Oceania';

SELECT DISTINCT(basic_unit)
FROM currencies c 
ORDER BY basic_unit;

SELECT basic_unit
FROM currencies c
WHERE code IN
   (SELECT code
   FROM countries c2 
   WHERE continent = 'Oceania')
ORDER BY basic_unit;




-- Anti Join
SELECT code, country_name
FROM countries c 
WHERE continent = 'Oceania'
  AND code NOT IN
    (SELECT code
    FROM currencies c2);



-- Subquery inside WHERE
-- Subqueries inside WHERE can either be from the same table or a different table
-- The goal is to figure out which countries had high average life expectancies in 2015.
-- That is life_expectancy above 1.15 * avg_life_expectancy
-- Populations has all the columns needed for the query
-- So you will nest a subquery from the populations table 
-- inside another query from the same table, populations
-- Let's break it down
-- Select average life_expectancy from the populations table
SELECT AVG(life_expectancy)
FROM populations
-- Filter for the year 2015
WHERE year = 2015;

SELECT life_expectancy
FROM populations p 
WHERE life_expectancy > 1.15 *
   (SELECT AVG(life_expectancy)
   FROM populations p2
   WHERE YEAR = 2015);

-- OR
SELECT life_expectancy
FROM populations p 
WHERE YEAR = 2015
  AND life_expectancy > 1.15 *
    (SELECT AVG(life_expectancy)
    FROM populations p2
    WHERE YEAR = 2015);



-- Subquery inside WHERE
-- WHERE do people live?
-- Identify capital cities in order of largest to smallest population.
-- Use countries and cities tables
SELECT name, country_code, urbanarea_pop
FROM cities c
WHERE name IN 
     (SELECT capital
     FROM countries c2)
ORDER BY c.urbanarea_pop DESC;





-- Subquery inside SELECT
-- Let's explore how some queries can be written using either a join or a subquery.
-- Step 1: Use LEFT JOIN and GROUP BY
-- Step 2: Use nested query to return the same result as Step 1
-- Select the nine countries with the most cities appearing in the cities
-- Most cities = COUNT(cities.name)
SELECT c.country_name AS country , COUNT(c2.name) AS cities_num
FROM countries c 
LEFT JOIN cities c2
ON c.code = c2.country_code
GROUP BY c.country_name
ORDER BY cities_num DESC
LIMIT 9;

-- Step 2: nested query
SELECT COUNT(name) AS cities_num
FROM cities c;

SELECT c.country_name AS country,
       (SELECT COUNT(c2.name) 
       FROM cities c2
       WHERE c2.country_code = c.code) AS cities_num
FROM countries c 
ORDER BY cities_num DESC
LIMIT 9;



-- Subquery inside FROM
-- Subqueries inside FROM can help select columns from multiple tables in a single query.
-- Determine the number of languages spoken for each country.
-- Present this information alongside each country's local_name, 
-- which is a field only present in the countries table and not in the languages table
-- Break it down
SELECT code, COUNT(name) AS lang_num
FROM languages l
GROUP BY code;


SELECT c.local_name, sub.lang_num
FROM countries c,
     (SELECT code, COUNT(name) AS lang_num
     FROM languages l
     GROUP BY l.code) AS sub
WHERE c.code = sub.code
ORDER BY lang_num DESC;



-- Subquery challenge
-- Analyze inflation and unemployment rate for certain countries in 2015
-- countries with "Republic" or "Monarchy" as their form of government.
SELECT code, inflation_rate , unemployment_rate 
FROM economies e
WHERE year = 2015;

SELECT code, gov_form 
FROM countries c 
WHERE gov_form LIKE '%Republic%' 
  OR gov_form LIKE '%Monarchy%';



SELECT code, inflation_rate , unemployment_rate 
FROM economies e
WHERE year = 2015
  AND code IN
    (SELECT code
    FROM countries c
    WHERE gov_form LIKE '%Republic%' 
      OR gov_form LIKE '%Monarchy%')
ORDER BY e.inflation_rate;



-- Final challenge
-- Determine the top 10 capital cities in Europe and the Americas by city_perc
-- city_perc = city_proper_pop / metroarea_pop * 100
-- Break it down
SELECT code, 
       capital, 
       continent
FROM countries c 
WHERE c.continent LIKE 'Europe' 
   OR c.continent LIKE '%America%';

SELECT metroarea_pop, 
       city_proper_pop / metroarea_pop * 100 AS city_perc
FROM cities c;




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
    




  
