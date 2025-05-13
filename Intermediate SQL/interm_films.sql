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
