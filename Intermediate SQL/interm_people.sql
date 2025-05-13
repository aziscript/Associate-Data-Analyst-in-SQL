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

-- Count the number of records in the people table
SELECT COUNT(*) AS count_records
FROM people;

-- Count the number of birthdates in the people table
SELECT COUNT(birthdate) as count_birthdate
FROM people;
