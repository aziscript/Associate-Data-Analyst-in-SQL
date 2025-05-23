
SELECT *
FROM students;

SELECT COUNT(*) AS students_count
FROM students;

SELECT stay, todep, tosc, tosc
FROM students
LIMIT 50;

-- How does the length of stay impact the average mental health diagnostic scores of international students?

-- Find the number of international students and their average scores by length of stay, in descending order of length of stay
SELECT stay, 
       COUNT(*) AS count_int,
       ROUND(AVG(todep)::numeric, 2) AS average_phq, 
       ROUND(AVG(tosc)::numeric, 2) AS average_scs, 
       ROUND(AVG(toas)::numeric, 2) AS average_as
FROM students
WHERE inter_dom = 'Inter'
GROUP BY stay
ORDER BY stay DESC
LIMIT 9;