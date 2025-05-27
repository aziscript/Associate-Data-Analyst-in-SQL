SELECT *
FROM people;

SELECT COUNT(*) AS total_rows,
       COUNT(birthdate) AS non_null_birthdates,
       COUNT(*) - COUNT(birthdate) AS null_birthdates,
       COUNT(*) FILTER (WHERE birthdate = '') AS empty_string_birthdates
FROM people;

UPDATE people
SET birthdate = NULL
WHERE birthdate = '';

UPDATE people
SET deathdate = NULL
WHERE deathdate = '';

SELECT *
FROM people
LIMIT 10;

-- Count the number of records in the people table
SELECT COUNT(*) AS count_records
FROM people;

-- Count the number of birthdates in the people table
SELECT COUNT(birthdate) as count_birthdate
FROM people;

-- Select the names that start with B
SELECT name
FROM people
WHERE name LIKE 'B%';

SELECT name
FROM people
-- Select the names that have r as the second letter
WHERE name LIKE '_r%';

SELECT name
FROM people
-- Select names that don't start with A
WHERE name NOT LIKE 'A%';

-- Calculate the percentage of people who are no longer alive
SELECT COUNT(deathdate) * 100.0 / COUNT(*) AS percentage_dead
FROM people;

-- Select name from people and sort alphabetically
SELECT name
FROM people
ORDER BY name;