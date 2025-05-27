SELECT *
FROM country c 
WHERE "name" = 'Germany';


-- Select Germany teams 15617:19305
SELECT *
FROM team t
WHERE t.id >= 15617 
   AND t.id <= 19305;

-- Select Germany matches 7809
SELECT *
FROM "match" m 
WHERE m.country_id = 7809;


-- Create teams_germany table
CREATE TABLE teams_germany AS
SELECT *
FROM team t
WHERE t.id >= 15617
   AND t.id <= 19305;

-- teams_germany
SELECT *
FROM teams_germany tg;


-- Create matches_germany table
CREATE TABLE matches_germany AS
SELECT *
FROM "match" m
WHERE m.country_id = 7809;

-- matches_germany 
SELECT *
FROM matches_germany mg;




-- Select italy country
SELECT *
FROM country c 
WHERE c."name" = 'Italy';

-- Select italy matches
SELECT *
FROM "match" m 
WHERE m.country_id = 10257;

-- Select italy teams
SELECT *
FROM team t 
WHERE t.id >= 20513 
  AND t.id <= 25048;

-- Create matches_italy table
CREATE TABLE matches_italy AS
SELECT *
FROM "match" m 
WHERE m.country_id = 10257;


-- Create teams_italy table
CREATE TABLE teams_italy AS
SELECT *
FROM team t 
WHERE t.id >= 20513 
  AND t.id <= 25048;



-- Select spain country
SELECT *
FROM country c 
WHERE c."name" = 'Spain';

-- Select spain matches
SELECT *
FROM "match" m 
WHERE m.country_id = 21518;

-- Select spain teams
SELECT *
FROM team t 
WHERE t.id >= 43035 
  AND t.id <= 47612;

-- Create matches_spain table
CREATE TABLE matches_spain AS
SELECT *
FROM "match" m 
WHERE m.country_id = 21518;


-- Create teams_spain table
CREATE TABLE teams_spain AS 
SELECT *
FROM team t 
WHERE t.id >= 43035 
  AND t.id <= 47612;

SELECT *
FROM matches_italy mi;
