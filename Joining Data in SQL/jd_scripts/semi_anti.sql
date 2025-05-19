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

SELECT code, country_name
FROM countries
WHERE continent = 'Oceania'
-- Filter for countries not included in the bracketed subquery
  AND code NOT IN
    (SELECT code
    FROM currencies);