CREATE TABLE IF NOT EXISTS public.films (
    id BIGINT,
    title VARCHAR(255),
    release_year INT,
    country VARCHAR(100),
    duration INT,
    "language" VARCHAR(100),
    certification VARCHAR(50),
    gross BIGINT,
    budget BIGINT
);


SELECT *
FROM public.films
WHERE TRIM(country) = '' OR TRIM("language") = '';

UPDATE public.films
SET country = NULL
WHERE TRIM(country) = '';

UPDATE public.films
SET "language" = NULL
WHERE TRIM("language") = '';

SELECT *
FROM films
LIMIT 10;

-- Count the records for languages and countries represented in the films table
SELECT COUNT(language) AS count_languages, COUNT(country) AS count_countries
FROM films;

-- Return the unique countries from the films table
SELECT DISTINCT country
FROM films;

-- Count the distinct countries from the films table
SELECT COUNT(DISTINCT country) AS count_distinct_countries
from films;

-- Count the Spanish-language films
SELECT COUNT(language) AS count_spanish
FROM films
WHERE language = 'Spanish';

-- Select the title and release_year for all German-language films released before 2000
SELECT title, release_year
FROM films
WHERE language = 'German' AND release_year < 2000;

-- Update the query to see all German-language films released after 2000
SELECT title, release_year
FROM films
WHERE release_year > 2000
	AND language = 'German';

-- Select all records for German-language films released after 2000 and before 2010
SELECT *
FROM films
WHERE language = 'German' AND release_year > 2000 AND release_year < 2010;

-- Find the title and year of films from the 1990 or 1999
SELECT title, release_year
FROM films
WHERE release_year = 1990 OR release_year = 1999;

SELECT title, release_year
FROM films
WHERE (release_year = 1990 OR release_year = 1999)
-- Add a filter to see only English or Spanish-language films
	AND (language = 'English' OR language = 'Spanish');

SELECT title, release_year
FROM films
WHERE (release_year = 1990 OR release_year = 1999)
	AND (language = 'English' OR language = 'Spanish')
-- Filter films with more than $2,000,000 gross
	AND gross > 2000000;

-- Select the title and release_year for films released between 1990 and 2000
SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 AND 2000;

SELECT title, release_year
FROM films
WHERE (release_year BETWEEN 1990 AND 2000)
-- Narrow down your query to films with budgets > $100 million
	AND budget > 100000000;

SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 AND 2000
	AND budget > 100000000
-- Restrict the query to only Spanish-language films
	AND language = 'Spanish';

SELECT title, release_year
FROM films
WHERE release_year BETWEEN 1990 AND 2000
	AND budget > 100000000
-- Amend the query to include Spanish or French-language films
	AND (language='Spanish' OR language='French');

-- Find the title and release_year for all films over two hours in length released in 1990 and 2000
SELECT title, release_year
FROM films
WHERE release_year IN (1990, 2000)
  AND duration > 120;

-- Find the title and language of all films in English, Spanish, and French
SELECT title, language
FROM films
WHERE language IN ('English', 'Spanish', 'French');

-- Find the title, certification, and language all films certified NC-17 or R that are in English, Italian, or Greek
SELECT title, certification, language
FROM films
WHERE certification IN ('NC-17', 'R')
  AND language IN ('English', 'Italian', 'Greek');

-- Count the unique titles
SELECT COUNT(DISTINCT title) AS nineties_english_films_for_teens
FROM films
-- Filter to release_years to between 1990 and 1999
WHERE release_year BETWEEN 1990 AND 1999
-- Filter to English-language films
	AND language = 'English'
-- Narrow it down to G, PG, and PG-13 certifications
	AND certification IN ('G', 'PG', 'PG-13');

-- List all film titles with missing budgets
SELECT title AS no_budget_info
FROM films
WHERE budget IS NULL;

-- Count the number of films we have language data for
SELECT COUNT(*) AS count_language_known
FROM films
WHERE language IS NOT NULL;

-- Query the sum of film durations
SELECT SUM(duration) AS total_duration
FROM films;

-- Calculate the average duration of all films
SELECT AVG(duration) AS average_duration
FROM films;

-- Find the latest release_year
SELECT MAX(release_year) AS latest_year
FROM films;

-- Find the duration of the shortest film
SELECT MIN(duration) AS shortest_film
FROM films;

-- Calculate the sum of gross from the year 2000 or later
SELECT SUM(gross) AS total_gross
FROM films
WHERE release_year >= 2000;

-- Calculate the average gross of films that start with A
SELECT AVG(gross) AS avg_gross_A
FROM films
WHERE title LIKE 'A%';

-- Calculate the lowest gross film in 1994
SELECT MIN(gross) AS lowest_gross
FROM films
WHERE release_year = 1994;

-- Calculate the highest gross film released between 2000-2012
SELECT MAX(gross) AS highest_gross
FROM films
WHERE release_year BETWEEN 2000 AND 2012;

-- Calculate the average budget rounded to the thousands
SELECT ROUND(AVG(budget), -3) AS avg_budget_thousands
FROM films;

/*The ROUND() function is very handy when making 
 financial calculations to get a top-level view or 
 specify to the penny or cent.*/

-- Calculate the title and duration_hours from films
SELECT title, (duration / 60.0) AS duration_hours
FROM films;

-- Find the number of decades in the films table
SELECT (MAX(release_year) - MIN(release_year)) / 10.0 AS number_of_decades
FROM films;

-- Round duration_hours to two decimal places
SELECT title, ROUND(duration / 60.0, 2) AS duration_hours
FROM films;
