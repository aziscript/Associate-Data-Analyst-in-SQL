
-- COUNT using CASE WHEN
-- Do the number of soccer matches played in a given European country differ across seasons?
-- You will examine the number of matches played in 3 seasons within each country

-- Count games from the 2012/2013 season
SELECT c."name" AS country,
       COUNT(CASE WHEN m.season = '2012/2013' 
               THEN m.id ELSE NULL END) AS matches_2012_2013
FROM country c
LEFT JOIN "match" m 
ON c.id = m.country_id
GROUP BY country;



-- count the number of matches played in each country during the 2012/2013, 2013/2014, and 2014/2015 match seasons.
SELECT c."name" AS country,
       COUNT(CASE WHEN m.season = '2012/2013' 
               THEN m.id ELSE NULL END) AS matches_2012_2013,
       COUNT(CASE WHEN m.season = '2013/2014'
               THEN m.id ELSE NULL END) AS matches_2013_2014,
       COUNT(CASE WHEN m.season = '2014/2015'
               THEN m.id ELSE NULL END) AS matches_2014_2015
FROM country c
LEFT JOIN "match" m 
ON c.id = m.country_id
GROUP BY country;


-- COUNT and CASE WHEN with multiple conditions
-- Determine the total number of matches won by the home team in each country 
-- during the 2012/2013, 2013/2014, and 2014/2015 seasons.
SELECT c."name" AS country,
       SUM(CASE WHEN m.season = '2012/2013' AND m.home_goal > m.away_goal
               THEN 1 ELSE 0 END) AS matches_2012_2013,
       SUM(CASE WHEN m.season = '2013/2014' AND m.home_goal > m.away_goal
               THEN 1 ELSE 0 END) AS matches_2013_2014,
       SUM(CASE WHEN m.season = '2014/2015' AND m.home_goal > m.away_goal
               THEN 1 ELSE 0 END) AS matches_2014_2015
FROM country c
LEFT JOIN "match" m 
ON c.id = m.country_id
GROUP BY country;



-- Calculating percent with CASE and AVG
-- Examine the number of wins, losses, and ties in each country.


-- Subqueries in the WHERE clause
-- Only returns a single column
/* These are useful for filtering results based on information 
 * you'd have to calculate separately beforehand.*/
SELECT *
FROM "match" m 
WHERE m.season = '2013/2014';

-- Create the matches_2013_2014 table
CREATE TABLE matches_2013_2014 AS
SELECT *
FROM "match" m 
WHERE m.season = '2013/2014';

SELECT *
FROM matches_2013_2014 m;

-- Find matches where the total goals exceed 3x the average goals in the matches_2013_2014 table.
-- Break it down first
SELECT 3 * AVG(home_goal + away_goal) AS avg_goals
FROM matches_2013_2014 m;

SELECT m."date",
       m.home_goal,
       m.away_goal
FROM matches_2013_2014 m 
WHERE (m.home_goal + m.away_goal) > 
      (SELECT 
          3 * AVG(m2.home_goal + m2.away_goal)
       FROM matches_2013_2014 m2)
       
       
       
-- Filtering using a subquery with a list
-- Generate a list of teams that never played a game in their home city.
/*As long as the values in your list match a column in your main query's table, 
 * you don't need to use a join -- even if the list is from a separate table.*/
SELECT t.team_long_name,
       t.team_short_name
FROM team t
WHERE t.team_api_id NOT IN
      (SELECT DISTINCT m.hometeam_id
       FROM "match" m);

-- Filtering with more complex subquery conditions
-- Create a list of teams that scored 8 or more goals in a home match.
SELECT t.team_long_name,
       t.team_short_name
FROM team t
WHERE t.team_api_id IN
      (SELECT m.hometeam_id
       FROM "match" m
       WHERE m.home_goal >= 8);



-- Joining Subqueries in FROM
/*
A subquery in FROM is an effective way of answering detailed questions 
that requires filtering or transforming data before including it in your final results.
*/
-- Generate a count of matches in each country 
-- where the total goals was higher than 10. That's a lot of goals!
SELECT m.country_id, 
       m.id, 
       m.home_goal, 
       m.away_goal
FROM "match" m 
WHERE (m.home_goal + m.away_goal) >= 10;

SELECT c.name AS country_name,
       COUNT(sub.id)
FROM country c 
INNER JOIN 
          (SELECT m.country_id,
                  m.id
           FROM "match" m 
           WHERE (m.home_goal + m.away_goal) >= 10) AS sub
ON c.id = sub.country_id
GROUP BY country_name;


-- Building on Subqueries in FROM
-- When they were played
-- During which seasons,
-- How many of the goals were home versus away goals.
SELECT c."name" AS country,
       m."date",
       m.home_goal,
       m.away_goal,
       (m.home_goal + m.away_goal) AS total_goals
FROM "match" m 
LEFT JOIN country c 
ON m.country_id = c.id;

SELECT country,
       date,
       home_goal,
       away_goal 
FROM 
    (SELECT c."name" AS country,
            m."date",
            m.home_goal,
            m.away_goal,
            (m.home_goal + m.away_goal) AS total_goals
     FROM "match" m
     LEFT JOIN country c
     ON m.country_id = c.id) AS subq
WHERE subq.total_goals >= 10;



-- Add a subquery to the SELECT clause
/*Subqueries in SELECT statements generate a single value 
that allow you to pass an aggregate value down a data frame. 
This is useful for performing calculations on data within your database.*/
-- Calculate and compare each league's average total goals to the overall average goals

-- Overall average(subquery)
SELECT ROUND(AVG(m.home_goal + m.away_goal), 2) AS overall_avg
FROM "match" m 
WHERE m.season = '2013/2014';

-- Average by league(main query)
SELECT l."name" AS league,
       ROUND(AVG(m.home_goal + m.away_goal), 2) AS avg_gaols
FROM league l 
LEFT JOIN "match" m 
ON l.country_id = m.country_id
WHERE m.season = '2013/2014'
GROUP BY league;

SELECT l."name" AS league,
       ROUND(AVG(m.home_goal + m.away_goal), 2) AS avg_gaols,
       (SELECT ROUND(AVG(m2.home_goal + m2.away_goal), 2)
        FROM "match" m2
        WHERE m2.season = '2013/2014') AS overall_avg
FROM league l 
LEFT JOIN "match" m 
ON l.country_id = m.country_id
WHERE m.season = '2013/2014'
GROUP BY league;

-- Filter only when avg_goals > overall_avg
SELECT league, avg_goals, overall_avg
FROM (
    SELECT l."name" AS league,
           ROUND(AVG(m.home_goal + m.away_goal), 2) AS avg_goals,
           (SELECT ROUND(AVG(m2.home_goal + m2.away_goal), 2)
            FROM "match" m2
            WHERE m2.season = '2013/2014') AS overall_avg
    FROM league l 
    LEFT JOIN "match" m 
    ON l.country_id = m.country_id
    WHERE m.season = '2013/2014'
    GROUP BY l."name"
) AS sub
WHERE avg_goals > overall_avg;


-- Subqueries in Select for Calculations
-- Add a column that directly compares these values by subtracting the overall average from the subquery.
SELECT l."name" AS league,
       ROUND(AVG(m.home_goal + m.away_goal), 2) AS avg_gaols,
       ROUND(AVG(m.home_goal + m.away_goal) -
       (SELECT AVG(m2.home_goal + m2.away_goal)
        FROM "match" m2
        WHERE m2.season = '2013/2014'), 2) AS diff
FROM league l 
LEFT JOIN "match" m 
ON l.country_id = m.country_id
WHERE m.season = '2013/2014'
GROUP BY league;


SELECT l."name" AS league,
       -- avg_goals by leauge
       ROUND(AVG(m.home_goal + m.away_goal), 2) AS avg_goals,
       -- overall_goals
       (SELECT ROUND(AVG(m2.home_goal + m2.away_goal), 2)
        FROM "match" m2 
        WHERE m2.season = '2013/2014') AS overall_goals,
        -- diff btw avg_goals and overall_goals
       ROUND(AVG(m.home_goal + m.away_goal) -
       (SELECT AVG(m2.home_goal + m2.away_goal)
        FROM "match" m2
        WHERE m2.season = '2013/2014'), 2) AS diff
FROM league l 
LEFT JOIN "match" m 
ON l.country_id = m.country_id
WHERE m.season = '2013/2014'
GROUP BY league;

-- Subqueries inside FROM
SELECT league,
       avg_goals,
       overall_goals,
       diff
FROM 
     (SELECT l."name" AS league,
       -- avg_goals by leauge
       ROUND(AVG(m.home_goal + m.away_goal), 2) AS avg_goals,
       -- overall_goals
       (SELECT ROUND(AVG(m2.home_goal + m2.away_goal), 2)
        FROM "match" m2 
        WHERE m2.season = '2013/2014') AS overall_goals,
        -- diff btw avg_goals and overall_goals
       ROUND(AVG(m.home_goal + m.away_goal) -
       (SELECT AVG(m2.home_goal + m2.away_goal)
        FROM "match" m2
        WHERE m2.season = '2013/2014'), 2) AS diff
FROM league l 
LEFT JOIN "match" m 
ON l.country_id = m.country_id
WHERE m.season = '2013/2014'
GROUP BY league) AS sub
WHERE avg_goals > overall_goals
ORDER BY diff DESC;


-- ALL the subqueries EVERYWHERE
-- Examine the average goals scored in each stage of a match.
-- Does the average number of goals scored change as the stakes 
-- get higher from one stage to the next?
-- Calculate and compare each stage's average total goals to the overall average goals

-- avg_goals by stage
SELECT m.stage,
       ROUND(AVG(m.home_goal + m.away_goal), 2) AS avg_goals,
       (SELECT ROUND(AVG(m2.home_goal + m2.away_goal), 2)
        FROM "match" m2
        WHERE m2.season = '2012/2013') AS overall
FROM "match" m 
WHERE m.season = '2012/2013'
GROUP BY m.stage;

-- Find stages where avg_goal > overall
SELECT sub.stage,
       sub.avg_goals
FROM 
     (SELECT m.stage,
             ROUND(AVG(m.home_goal + m.away_goal), 2) AS avg_goals,
             (SELECT ROUND(AVG(m2.home_goal + m2.away_goal), 2)
              FROM "match" m2
              WHERE m2.season = '2012/2013') AS overall
      FROM "match" m 
      WHERE m.season = '2012/2013'
      GROUP BY m.stage) AS sub
WHERE sub.avg_goals > sub.overall;

-- Compare the average number of goals scored in each stage to the total.
SELECT sub.stage,
       sub.avg_goals,
       sub.overall
FROM 
     (SELECT m.stage,
             ROUND(AVG(m.home_goal + m.away_goal), 2) AS avg_goals,
             (SELECT ROUND(AVG(m2.home_goal + m2.away_goal), 2)
              FROM "match" m2
              WHERE m2.season = '2012/2013') AS overall
      FROM "match" m 
      WHERE m.season = '2012/2013'
      GROUP BY m.stage) AS sub
WHERE sub.avg_goals > sub.overall;



-- Basic Correlated Subqueries
/*
Correlated subqueries are subqueries that reference one or more columns in the main query. 
Correlated subqueries depend on information in the main query to run, 
and thus, cannot be executed on their own.
*/
-- Examine matches with scores that are extreme outliers for each country 
-- above 3 times the average score!
SELECT main.country_id,
       main."date", 
       main.home_goal,
       main.away_goal
FROM "match" main
WHERE (home_goal + away_goal) >
          (SELECT AVG((sub.home_goal + sub.away_goal) * 3)
           FROM "match" sub
           WHERE main.country_id = sub.country_id);




-- Correlated subquery with multiple conditions
-- what was the highest scoring match for each country, in each season?
SELECT main.country_id,
       main."date", 
       main.home_goal,
       main.away_goal
FROM "match" main
WHERE (home_goal + away_goal) =
          (SELECT MAX(sub.home_goal + sub.away_goal) AS max_goals
           FROM "match" sub
           WHERE main.country_id = sub.country_id 
                 AND main.season = sub.season);





-- Breakdown
-- Create a table with total_goals column
SELECT main."date",
       main.season,
       main.country_id,
       main.home_goal,
       main.away_goal,
       main.home_goal + main.away_goal AS total_goals
FROM "match" main;

-- Create a table with max_goals column
-- Highest number of goals per country and season
SELECT m.country_id,
       m.season,
       MAX(m.home_goal + m.away_goal) AS max_goals
FROM "match" m 
GROUP BY m.country_id, m.season;


-- Joining the two tables(Option A)
-- Using JOIN
SELECT main."date",
       main.season,
       main.country_id,
       main.home_goal,
       main.away_goal,
       main.home_goal + main.away_goal AS total_goals,
       max_goals_sub.max_goals
FROM "match" main
JOIN 
    (SELECT m.country_id,
            m.season,
            MAX(m.home_goal + m.away_goal) AS max_goals
     FROM "match" m
     GROUP BY m.country_id, m.season) AS max_goals_sub
ON main.country_id = max_goals_sub.country_id
  AND main.season = max_goals_sub.season
WHERE (main.home_goal  + main.away_goal) = max_goals_sub.max_goals;


-- Joining the two tables(Option B) 
-- Inside FROM clause
SELECT main."date",
       main.season,
       main.country_id,
       main.home_goal,
       main.away_goal,
       main.home_goal + main.away_goal AS total_goals,
       max_goals_sub.max_goals
FROM "match" main,
     (SELECT m.country_id,
             m.season,
             MAX(m.home_goal + m.away_goal) AS max_goals
      FROM "match" m 
      GROUP BY m.country_id, m.season) AS max_goals_sub
WHERE max_goals_sub.country_id = main.country_id
  AND max_goals_sub.season = main.season
   AND (main.home_goal  + main.away_goal) = max_goals_sub.max_goals;



-- Nested simple subqueries
-- Examine the highest total number of goals in each season, overall, and during July across all seasons.
-- Breakdown
-- overall max goals scored in a match
SELECT MAX(m.home_goal + m.away_goal) AS overall_max_goals
FROM "match" m;

-- Select the max number of goals scored in any match in July
SELECT MAX(m.home_goal + m.away_goal) AS july_max_goals
FROM "match" m 
WHERE EXTRACT(MONTH FROM date::date) = 7;

-- main query(max goals by season)
SELECT m.season,
       MAX(m.home_goal + m.away_goal) AS max_goals
FROM "match" m 
GROUP BY m.season;

-- Nested query
SELECT
    season,
    MAX(home_goal + away_goal) AS max_goals,
    -- Select the overall max goals scored in a match
    (SELECT MAX(home_goal + away_goal) FROM match) AS overall_max_goals,
    -- Select the max number of goals scored in any match in July
    (SELECT MAX(home_goal + away_goal) 
     FROM match
     WHERE EXTRACT(MONTH FROM date::date) = 7) AS july_max_goals
FROM match
GROUP BY season;




-- Nest a subquery in FROM
-- What's the average number of matches per season where a team scored 5 or more goals? 
--How does this differ by country?
-- group by season and country
-- count matches(id)
-- breakdown

-- table where a team scored 5 or more goals
SELECT m.country_id,
       m.id,
       m.season
FROM "match" m 
WHERE m.home_goal >= 5 OR m.away_goal >= 5;

-- table with count of where a team scored 5 or more goals by season and country
SELECT subq.country_id,
       subq.season,
       COUNT(subq.id) AS matches
FROM 
    (SELECT m.country_id,
            m.id,
            m.season
     FROM "match" m
     WHERE m.home_goal >= 5 OR m.away_goal >= 5) AS subq
GROUP BY subq.country_id, subq.season;

--  average number of matches
SELECT c.id, c."name" AS country
FROM country c; 

-- join without grouping
SELECT c.id,
      c."name" AS country,
      outer_s.country_id,
      outer_s.season,
      outer_s.matches
FROM country c
LEFT JOIN 
		(SELECT subq.country_id,
		       subq.season,
		       COUNT(subq.id) AS matches
		FROM 
		    (SELECT m.country_id,
		            m.id,
		            m.season
		     FROM "match" m
		     WHERE m.home_goal >= 5 OR m.away_goal >= 5) AS subq
		GROUP BY subq.country_id, subq.season
		) AS outer_s
ON c.id = outer_s.country_id;

-- by country
SELECT c."name" AS country,
       ROUND(AVG(outer_s.matches), 2) AS avg_seasonal_high_scores
FROM country c
LEFT JOIN 
		(SELECT subq.country_id,
		       subq.season,
		       COUNT(subq.id) AS matches
		FROM 
		    (SELECT m.country_id,
		            m.id,
		            m.season
		     FROM "match" m
		     WHERE m.home_goal >= 5 OR m.away_goal >= 5) AS subq
		GROUP BY subq.country_id, subq.season
		) AS outer_s
ON c.id = outer_s.country_id
GROUP BY country;


-- Breakdown
SELECT m.country_id,
       m.id
FROM "match" m 
WHERE (m.home_goal + m.away_goal) >= 10;

SELECT *
FROM league l;

SELECT l."name" AS league,
       COUNT(sub.id) AS matches
FROM league l 
LEFT JOIN (
       SELECT m.country_id,
              m.id,
              m.home_goal,
              m.away_goal
       FROM "match" m
       WHERE (m.home_goal + m.away_goal) >= 10
) AS sub
ON l.id = sub.country_id
GROUP BY league
ORDER BY matches DESC;


                
-- Count the Number of matches in each leauge where goal is >= 10
-- Set up your CTE
WITH match_list AS (
    SELECT 
  		country_id, 
  		id
    FROM "match" m 
    WHERE (home_goal + away_goal) >= 10)
-- Select league and count of matches from the CTE
SELECT
    l.name AS league,
    COUNT(match_list.id) AS matches
FROM league AS l
-- Join the CTE to the league table
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;


SELECT l."name" AS leauge,
       m."date",
       m.home_goal,
       m.away_goal,
       (m.home_goal + m.away_goal) AS total_goals
FROM "match" m 
LEFT JOIN league l 
ON m.country_id  = l.id;


-- Organizing with CTEs
WITH match_list AS (
        SELECT l."name" AS league,
               m."date",
               m.home_goal,
               m.away_goal,
               (m.home_goal + m.away_goal) AS total_goals
        FROM "match" m 
        LEFT JOIN league l 
        ON m.country_id = l.id
)
SELECT league,
       date,
       home_goal,
       away_goal 
FROM match_list 
WHERE total_goals >= 10;

-- CTEs with nested subqueries
-- Declare a CTE that calculates the total goals from matches in August of the 2013/2014 season.
WITH match_list AS (
        SELECT m.country_id,
               (m.home_goal + m.away_goal) AS goals
        FROM "match" m 
        WHERE m.id IN (
              SELECT m2.id
              FROM "match" m2 
              WHERE m2.season = '2013/2014'
                AND EXTRACT(MONTH FROM date::date) = 08
        )
)
SELECT l."name",
       ROUND(AVG(match_list.goals), 2)
FROM league l 
LEFT JOIN match_list 
ON l.id = match_list.country_id
GROUP BY l."name";






-- Perform this excercise using subqueries, correlated subqueries, and CTEs.
-- 1. Get team names with a subquery
-- home teams
SELECT m.id,
       t.team_long_name AS hometeam
FROM "match" m 
LEFT JOIN team t 
ON m.hometeam_id = t.team_api_id;

-- away teams
SELECT m.id,
       t.team_long_name AS awayteam
FROM "match" m 
LEFT JOIN team t 
ON m.awayteam_id = t.team_api_id;


SELECT m.date,
       hometeam,
       awayteam,
       m.home_goal,
       m.away_goal
FROM "match" m 
-- join hometeam
LEFT JOIN (
    SELECT m.id,
       t.team_long_name AS hometeam
    FROM "match" m 
    LEFT JOIN team t 
    ON m.hometeam_id = t.team_api_id 
) AS home
ON home.id = m.id
-- join awayteam
LEFT JOIN (
    SELECT m.id,
       t.team_long_name AS awayteam
    FROM "match" m 
    LEFT JOIN team t 
    ON m.awayteam_id = t.team_api_id
) AS away
ON away.id = m.id;


-- Get team names with correlated subqueries
-- Using a correlated subquery in the SELECT statement
SELECT m.date,
       (SELECT t.team_long_name
        FROM team t 
        WHERE t.team_api_id  = m.hometeam_id
       ) AS hometeam
FROM "match" m;

SELECT m.date,
       (SELECT t.team_long_name
        FROM team t 
        WHERE t.team_api_id  = m.hometeam_id
       ) AS hometeam,
       --away team
       (SELECT t.team_long_name
        FROM team t 
        WHERE t.team_api_id  = m.awayteam_id
       ) AS awayteam,
       m.home_goal,
       m.away_goal
FROM "match" m;


--- Get team names with CTEs
WITH home AS (
   SELECT m.id,
          m.date,
          t.team_long_name AS hometeam,
          m.home_goal
   FROM "match" m 
   LEFT JOIN team t
   ON m.hometeam_id = t.team_api_id
),
-- away team
away AS (
   SELECT m.id,
          m.date,
          t.team_long_name AS awayteam,
          m.away_goal
   FROM "match" m
   LEFT JOIN team t 
   ON m.awayteam_id = t.team_api_id
)
-- main query
SELECT home.date,
       home.hometeam,
       away.awayteam,
       home.home_goal,
       away.away_goal
FROM home
INNER JOIN away 
ON home.id = away.id;






   











