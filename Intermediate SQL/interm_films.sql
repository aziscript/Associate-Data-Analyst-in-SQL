CREATE TABLE IF NOT EXISTS public.films (
    id BIGINT,
    title VARCHAR(255),
    release_year INT,
    country VARCHAR(100),
    duration INT,
    "language" VARCHAR(100),
    certification VARCHAR(20),
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

