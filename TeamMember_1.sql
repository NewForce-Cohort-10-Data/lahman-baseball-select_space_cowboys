--Team Member 1: Focused on the questions: 2, 6, and 10 within our group.
--Completed additional questions and reviewed some of the answers within the group.
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




--ADDITIONAL PRACTICE EXERCISES:


--1.What range of years for baseball games played does the provided database cover?

SELECT
yearid,
g
FROM
teams;

--//1871 was the earliest year that a baseball game was played within the database,
--and 2016 was the last year that a baseball game was played within the database.

--3.
--Find all players in the database who played at Vanderbilt University. 
--Create a list showing each player’s first and last names 
--as well as the total salary they earned in the major leagues. 
--Sort this list in descending order by the total salary earned. 
--Which Vanderbilt player earned the most money in the majors?

SELECT
schoolname, p.namefirst, p.namelast, SUM(ROUND(s.salary::NUMERIC, 2)) AS total_salary
FROM schools
INNER JOIN collegeplaying AS cp USING(schoolid)
INNER JOIN people AS p USING(playerid)
INNER JOIN salaries AS s USING(playerid)
WHERE schoolname = 'Vanderbilt University'
GROUP BY schoolname, p.namefirst, p.namelast
ORDER BY total_salary DESC;

--//David Price had the highest total salary-$245,553,888.00.

--4.Using the fielding table, group players into three groups based on their position: 
--label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", 
--and those with position "P" or "C" as "Battery". 
--Determine the number of putouts made by each of these three groups in 2016.

SELECT 
    CASE
        WHEN pos = 'OF' THEN 'Outfield'
        WHEN pos IN ('SS', '1B', '2B', '3B') THEN 'Infield'
        WHEN pos IN ('P', 'C') THEN 'Battery'
        ELSE 'Missing'
    END AS position_group,
    SUM(po) AS total_putouts
FROM fielding
WHERE yearid = 2016
GROUP BY position_group
ORDER BY total_putouts DESC;

--//Infield had 58,934 putouts, battery had 41,424 putouts, and outfield had 29,560 putouts.

--5.Find the average number of strikeouts per game by decade since 1920. 
--Round the numbers you report to 2 decimal places. 
--Do the same for home runs per game. Do you see any trends?

SELECT
(yearid / 10) * 10 AS decade,
ROUND(SUM(so) * 1.0 / SUM(g), 2) AS avg_strikeouts_pergame,
ROUND(SUM(hr) * 1.0 / SUM (g), 2) AS avg_homeruns_pergame
FROM batting
WHERE yearid >= 1920
GROUP BY decade
ORDER BY decade ASC;

--//The top row shows the 1920's decade with 0.25 avg strikeouts per game and 0.04 avg homeruns per game.

--7. From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? 
--What is the smallest number of wins for a team that did win the world series? 
--Doing this will probably result in an unusually small number of wins for a world series champion 
--determine why this is the case. Then redo your query, excluding the problem year.
--How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? 
--What percentage of the time?

SELECT
(COUNT(*) * 1.0 / (SELECT COUNT(*)
				FROM teams
				WHERE yearid >= 1970 
                AND yearid <= 2016
				AND yearid != 1981)) * 100
AS percentage
FROM (
    SELECT
yearid,
MAX(w) AS most_wins
FROM teams
WHERE yearid >= 1970 
      AND yearid <= 2016
	  AND yearid != 1981
GROUP BY yearid
) AS max_wins_per_year
INNER JOIN teams AS t ON max_wins_per_year.yearid = t.yearid
                      AND max_wins_per_year.most_wins = t.w
WHERE t.wswin = 'Y';

--//94.6% of the time, the team with the most wins also won the world series.

SELECT
yearid,
MAX(w) AS most_wins
FROM teams
WHERE yearid >= 1970 
AND yearid <= 2016
AND wswin = 'Y'
AND yearid != 1981
GROUP BY yearid;

--//Seattle Mariners in 2001 had the largest number of wins (116) that did not win the world series.
--//The LA Dodgers in 1981 had the smallest number of wins (63) that won the world series.


--8.Using the attendance figures from the homegames table...
--find the teams and parks which had the top 5 average attendance per game in 2016
--(Where average attendance is defined as total attendance divided by number of games)
--Only consider parks where there were at least 10 games played.
--Report the park name, team name, and average attendance.
--Repeat for the lowest 5 average attendance.

SELECT
parks.park_name, 
teams.name, 
SUM((homegames.attendance)/(homegames.games)) AS avg_attendance
from homegames 
INNER JOIN parks USING(park)
INNER JOIN teams ON homegames.team = teams.teamid
WHERE homegames.year = '2016'
AND homegames.games >= 10
GROUP BY parks.park_name, teams.name
ORDER BY avg_attendance DESC
LIMIT 5;

--//Busch Stadium III for the St. Louis Cardinals had an average attendance of 4,975,308 in 2016. 

SELECT
parks.park_name, 
teams.name, 
SUM((homegames.attendance)/(homegames.games)) AS avg_attendance
from homegames 
INNER JOIN parks USING(park)
INNER JOIN teams ON homegames.team = teams.teamid
WHERE homegames.year = '2016'
AND homegames.games >= 10
GROUP BY parks.park_name, teams.name
ORDER BY avg_attendance ASC
LIMIT 5;

--//Progressive Field for the Cleveland Blues had an average attendance of 19,650 in 2016. 

--9.Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? 
--Give their full name and the teams that they were managing when they won the award.

SELECT
p.namefirst, p.namelast
am.awardid AS manager_of_the_year,
am.lgid AS league
FROM awardsmanagers AS am
WHERE awardid = 'AL' OR awardid = 'NL'
INNER JOIN people AS p USING(playerid)
INNER JOIN teams USING(lgid);



--11.Is there any correlation between number of wins and team salary? 
--Use data from 2000 and later to answer this question. 
--As you do this analysis, keep in mind that salaries across the whole league tend to increase together, 
--so you may want to look on a year-by-year basis.

WITH team_salary AS (
SELECT 
	teamid,
	yearid,
	SUM(salary)::NUMERIC::MONEY AS total_salary
	FROM salaries
	WHERE salary IS NOT NULL
	GROUP BY teamid, yearid
)
SELECT 
	t.name,
	t.yearid,
	t.w AS wins,
	ts.total_salary
FROM teams AS t
INNER JOIN team_salary AS ts
ON t.teamid = ts.teamid AND t.yearid = ts.yearid
WHERE t.yearid >= 2000
ORDER BY t.yearid, t.w DESC;

--//It appears as though there is no direct correlation between wins and team salary. 
--//There is a rising trend across all team salaries over time.


 