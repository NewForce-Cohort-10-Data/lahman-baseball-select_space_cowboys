-- Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.

SELECT * 
FROM fielding;

SELECT namefirst, namelast, playerid,
CASE
WHEN f.pos = 'OF' THEN 'outfield'
WHEN f.pos IN ( 'SS', '1B', '2B', '3B') THEN 'infield'
WHEN f.pos IN ('P', 'C') THEN 'battery'
END AS player_group
FROM people p
INNER JOIN fielding f
USING (playerid);

WITH players_group AS (SELECT namefirst, namelast, playerid,
CASE
WHEN f.pos = 'OF' THEN 'outfield'
WHEN f.pos IN ( 'SS', '1B', '2B', '3B') THEN 'infield'
WHEN f.pos IN ('P', 'C') THEN 'battery'
END AS player_group
FROM people p
INNER JOIN fielding f
USING (playerid))
SELECT pg.player_group, SUM(f.po) AS total_put_outs
FROM players_group pg
INNER JOIN fielding f
ON pg.playerid = f.playerid
WHERE f.yearid = 2016
GROUP BY pg.player_group;


-- Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?


SELECT * 
FROM batting;

SELECT*
FROM teams;

SELECT
(t.yearid / 10) * 10 AS decade,  
ROUND(SUM(SO) * 1.0 / SUM(G), 2) AS avg_strikeouts_per_game,
ROUND(SUM(HR) * 1.0 / SUM(G), 2) AS avg_homeruns_per_game
FROM teams t
WHERE t.yearid >= 1920
GROUP BY decade
ORDER by decade DESC;


-- From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?

SELECT *
FROM teams;

SELECT teamid, MAX(W) AS total_wins
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
AND WSWin = 'N'
GROUP BY teamid
ORDER BY total_wins DESC;

SELECT yearid,teamid, MIN(W) AS total_wins
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
AND WSWin = 'Y'
GROUP BY teamid, yearid
ORDER BY total_wins ASC;

-- ANSWER
-- 1981 the season was split in half due to a strike-shortened season
-- and in 1995 wildcards were introduced which explains line 2 where SLN had 83 wins

SELECT yearid,teamid, MIN(W) AS total_wins
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
AND yearid != 1981
AND WSWin = 'Y'
GROUP BY teamid, yearid
ORDER BY total_wins ASC;

--  How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?


SELECT yearid, teamid, MAX(W) AS max_wins
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
GROUP BY yearid, teamid;

 SELECT yearid, teamid
 FROM teams
 WHERE yearid BETWEEN 1970 AND 2016
 AND WSWin = 'Y';
 



