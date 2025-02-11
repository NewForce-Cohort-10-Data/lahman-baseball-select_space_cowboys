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
INNER JOIN appearances USING(playerid)
INNER JOIN teams USING(teamid)
ORDER BY height ASC
LIMIT 1;

--//Eddie Gaedel played for the St. Louis Browns


--Q6.Find the player who had the most success stealing bases in 2016.
--Success is measured as the percentage of stolen base attempts which are successful. 
--(A stolen base attempt results either in a stolen base or being caught stealing.) 
--Consider only players who attempted at least 20 stolen bases.

SELECT 
playerid,
people.namefirst,
people.namelast,
yearid,
sb,
cs,
ROUND(sb * 1.0 / (sb + cs) * 100, 2) AS successful_steals
FROM batting
INNER JOIN people USING(playerid)
WHERE yearid = 2016
AND (sb + cs) >= 20
ORDER BY successful_steals DESC;

--//Chris Owings had the most success with stealing bases in 2016.

--Q10.
--Find all players who hit their career highest number of home runs in 2016.
--Consider only players who have played in the league for at least 10 years, 
--and who hit at least one home run in 2016. 
--Report the players' first and last names 
--and the number of home runs they hit in 2016.


WITH career_high AS (
SELECT playerid, MAX(hr) AS max_hr
FROM batting
WHERE hr >= 1
Group BY playerid
),
player_experience AS (
SELECT playerid
FROM batting
GROUP BY playerid
HAVING MAX(yearid) - MIN(yearid) >= 10
)
SELECT b.playerid, p.namefirst, p.namelast, b.hr
FROM batting AS b
INNER JOIN people AS p USING(playerid)
INNER JOIN career_high AS ch ON b.playerid = ch.playerid AND b.hr = ch.max_hr
INNER JOIN player_experience AS play on b.playerid = play.playerid
WHERE b.yearid = 2016
ORDER BY b.hr DESC;

--//Edwin Encarnacion at the very top, had a career high of 42 home runs in 2016. There were 7 other players listed from this query.



 