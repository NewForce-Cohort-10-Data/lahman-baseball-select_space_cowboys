-- Team Member 4: Historical Managerial & Pitching Success:
-- q1, q9, q13, q12
-- (Focus: Lookup Queries → Multi-Table Joins → Complex Performance Comparisons)



-- (Warm-up | Simple Lookup & Join Query)
-- Q9. Identify managers who won TSN Manager of the Year in both NL and AL.
-- Skillset: Multi-table JOINs, DISTINCT filtering, WHERE conditions.

-- (Intermediate | Pitcher Comparisons & Award Analysis)
-- Q13. Investigate whether left-handed pitchers are more effective (rarity, Cy Young wins, Hall of Fame).
-- Skillset: COUNT(), conditional filtering, JOINs with multiple tables.

-- (Advanced | Multi-Year Performance Impact on Attendance)
-- Q12. Investigate correlation between attendance and team success 
-- (Does winning increase attendance? Does making the playoffs impact attendance the next year?)
-- Skillset: JOINs across multiple seasons, year-over-year comparisons, percentage change calculations.



-- 1. What range of years for baseball games played does the provided database cover? 1871 - 2016

SELECT yearid
FROM teams
ORDER BY yearid 

--9. Which managers have won the TSN Manager of the Year award in both the National League (NL) 
--and the American League (AL)? Give their full name and the teams that they were managing when they won the award.
--Find TSN manager awards, find AL and NL, find manager name. 
--My rewrite: which managers won the TSN MoY award in the NL and AL? Give full name and teams managed when award was won. 

SELECT *
FROM managers
--notes: playerid, yearid, teamid, lgid

SELECT * 
FROM awardsmanagers
--gives me awardid, yearid, lgid, playerid

SELECT *
FROM people
--gives me namegiven

SELECT * 
from teams
--gives me name

SELECT * 
FROM appearances
--gives me yearid, lgid, playerid, teamid

--find distinct manager names, their playerids, their teams, and their years managed 


WITH manager_awards AS (
SELECT p.namegiven AS manager_name, 
		t.name AS team_name, 
		w.lgid AS league, 
		w.yearid AS award_year, 
		m.playerid
FROM managers as m
Inner join people as p using (playerid)
inner join teams as t USING (teamid, yearid)
inner join awardsmanagers as w using (playerid, yearid)
where w.awardid = 'TSN Manager of the Year'
	and w.lgid in ('AL', 'NL'))

SELECT manager_name, team_name, league, award_year
FROM manager_awards
WHERE playerid IN (
		SELECT playerid
		FROM manager_awards
		GROUP BY playerid
		HAVING COUNT (distinct league) = 2)
ORDER BY manager_name, award_year; 


--13. It is thought that since left-handed pitchers are more rare, causing batters to face them less often, 
-- that they are more effective. Investigate this claim and present evidence to either support or dispute this claim. 

--First, determine just how rare left-handed pitchers are compared with right-handed pitchers. 

--Are left-handed pitchers more likely to win the Cy Young Award? Are they more likely to make it into the hall of fame?
--Select the count of right pitchers, left hand pitches

select count (throws)
from people
--number pitchwers: 18135

SELECT count(throws) AS rthrows, 
FROM people
where throws = 'R'
--14480
--80 righty, 20 lefty


--hall of fame
select *
from halloffame


with lefty as 
	(SELECT DISTINCT playerid
	FROM people
	inner join pitching 
	using (playerid)
	where throws = 'L'
	)
select distinct l.playerid
from lefty as l
inner join halloffame as h
using (playerid)

--141 rows for lefty hall of famer pitcher

with righty as 
	(SELECT DISTINCT playerid
	FROM people
	inner join pitching 
	using (playerid)
	where throws = 'R'
	)
select distinct r.playerid
from righty as r
inner join halloffame as h
using (playerid)
--347 rows for righty hall of famer pitchers

--double checking with number of pitchers in hall of fame: 489 rather than expected 488--are there any ambidextrous pitchers????
--YES THERE IS ONE AND THEIR NAME IS PAT VENDITTE: he threw switch!!!!
--okay this makes sense now and math can proceed

with pitchers as 
	(SELECT DISTINCT playerid
	FROM people
	inner join pitching 
	using (playerid)
	)
select distinct r.playerid
from pitchers as r
inner join halloffame as h
using (playerid)

SELECT distinct playerid, throws, namefirst, namelast
from people
inner join pitching as r
using (playerid)
where throws NOT LIKE 'L' AND throws NOT LIKE 'R'

--better way to check values
SELECT count(distinct throws)
from people

--MATH SECTION
--(141/488)*100 = 29% of hall of fame pitchers are lefty 


--cy young
select *
from awardsplayers
where awardid ilike 'Cy%'
order by awardid
--total of 112 rows 

select count(distinct awardid)
from awardsplayers
where awardid ilike 'Cy%'
group by awardid
--1, helpfully

--how many 
select count(distinct playerid)
from awardsplayers
where awardid ilike 'Cy%'
--total of 77 distinct players 

--righty count of cy awardees: 53
with righty as 
	(SELECT DISTINCT playerid
	FROM people
	inner join pitching 
	using (playerid)
	where throws = 'R'
	)
select count(distinct r.playerid)
from righty as r
inner join awardsplayers
using (playerid)
where awardid ilike 'Cy%'

--lefty count cy awardees: 24
with lefty as 
	(SELECT DISTINCT playerid
	FROM people
	inner join pitching 
	using (playerid)
	where throws = 'L'
	)
select count(distinct l.playerid)
from lefty as l
inner join awardsplayers
using (playerid)
where awardid ilike 'Cy%'

--yay numbers align!!

--math time: lefty percentage: (24/77)*100 = 31% lefty

--leftys do out perform righty pitchers in awards. but how does that map to actual performance? TO BE CONTINUED 

--12. In this question, you will explore the connection between number of wins and attendance.
--Does there appear to be any correlation between attendance at home games and number of wins?
--Do teams that win the world series see a boost in attendance the following year? 
--What about teams that made the playoffs?
--Making the playoffs means either being a division winner or a wild card winner.
--controlling for population is really, really hard



--check all more complex queries for correct group by and inclusion of yearid



select *
from appearances

select *
from teams

with simplewl as
(select distinct yearid, name, teamid, w, l, ghome, attendance
from teams)
select yearid, teamid, sum(w) as totalwins, sum(attendance) as totalattendance
from simplewl
group by teamid, yearid, attendance, w

(select distinct yearid, name, teamid, w, l, ghome, attendance
from teams
where name = 'Minnesota Twins'
order by w desc)
--makes for fun graph

--strategy: approach it via min and max

select min(attendance), w, name, yearid
from teams
group by name, yearid, w, attendance
order by attendance

--does not seem to be a strong correlation between wins and attendance. let's investigate world series wins and attendance

select attendance, w, name, yearid
from teams
where WSWin = 'Y'
group by name, yearid, attendance, w
order by attendance


--this question does not control for the city's population in the year in question, which is a very key variable in judging
--should measuring attendance not be relative to the city's population? this also, crucially, lacks data for tv/streaming. 
--also does not include ball park size
--this limits the data in an interesting way. 




