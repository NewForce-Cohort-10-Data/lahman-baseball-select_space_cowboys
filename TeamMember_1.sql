--Team Member 1: Player Statistics & Performance Analysis
--(Focus: Basic lookups → Aggregation & Grouping → Conditional Logic & Ranking)
--(Warm-up)
--Q2. 
--Find the name and height of the shortest player in the database. 

SELECT 
namefirst, 
namelast, 
height
FROM people
ORDER BY height ASC;

--//Eddie Gaedel is the shortest player in the database with a height of 43 inches (3.58 feet).

--How many games did he play in? 
SELECT 
namefirst, 
namelast,
height,
g AS games
FROM people
INNER JOIN batting USING(playerid)
ORDER BY g, height ASC;

--//Eddie Gaedel played one game in his career.

--What is the name of the team for which he played?

SELECT 
namefirst, 
namelast,
height,
name
FROM people
LEFT JOIN teams
ON managershalf.teamid = teams.teamid
GROUP BY name
ORDER BY height ASC;

SELECT
*
FROM teams;

(Intermediate)
Q6. Find the most successful base stealer in 2016 (minimum 20 attempts).
(Advanced)
Q10. Find all players who hit their career-high home runs in 2016 (played at least 10 years, hit at least 1 HR).