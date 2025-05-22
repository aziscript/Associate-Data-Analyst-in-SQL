SELECT *
FROM reviews
LIMIT 10;

-- Select film_id and imdb_score with an imdb_score over 7.0
SELECT film_id, imbd_score
FROM reviews
WHERE imbd_score > 7.0;

-- Select film_id and facebook_likes for ten records with less than 1000 likes 
SELECT film_id, facebook_likes
FROM reviews
WHERE facebook_likes < 1000
LIMIT 10;

-- Count the records with at least 100,000 votes
SELECT COUNT(*) AS films_over_100K_votes
FROM reviews
WHERE num_votes >= 100000;

-- Round the average number of facebook_likes to one decimal place
SELECT ROUND(AVG(facebook_likes), 1) AS avg_facebook_likes
FROM reviews;


-- Challenge
-- Which titles in the reviews table have an IMDB score higher than 8.5?
SELECT film_id 
FROM reviews r 
WHERE imbd_score > 8.5;

-- Inner join
SELECT f.title, 
       r.imbd_score
FROM reviews r
INNER JOIN films f 
ON r.film_id = f.id
WHERE r.imbd_score > 8.5
ORDER BY imbd_score DESC;

-- Inside SELECT
SELECT r.imbd_score, 
       (SELECT f.title
       FROM films f
       WHERE f.id = r.film_id) AS title
FROM reviews r 
WHERE imbd_score > 8.5
ORDER BY r.imbd_score DESC;


SELECT 
       (SELECT f.title
       FROM films f
       WHERE f.id = r.film_id) AS title,
       r.imbd_score
FROM reviews r 
WHERE imbd_score > 8.5
ORDER BY r.imbd_score DESC;



-- Inside FROM
SELECT sub.movie_title, 
       r.imbd_score
FROM reviews r, 
     (SELECT f.id, 
             f.title AS movie_title
     FROM films f) AS sub
WHERE r.film_id = sub.id
ORDER BY r.imbd_score DESC;

