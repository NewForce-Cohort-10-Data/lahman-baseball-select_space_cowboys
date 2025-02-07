--bre teammember-1 (2,6,10)
--jacob teammember-2 (3,8,11)
--cyrus teammember-3 (4,5,7)
--emily teammember-4 (9,12,13)

--1 1871 - 2016
select min(year) as earliest_year, max(year) as latest_year
from homegames;

select*
from homegames;
select*
from people;
select*
from schools;
select*
from salaries
select*
from collegeplaying;
select*
from teams;

--3. Find all players in the database who played at Vanderbilt University.
--Create a list showing each player’s first and last names as well as the total
--salary they earned in the major leagues. Sort this list in descending order by
---the total salary earned. Which Vanderbilt player earned the most money in the majors?

--players, vanderbilt university>>>first,last,totalsalary(for major leagues)>>>sort desc
--by totalsalary

--David Price at $245,553,888.00
select namefirst, namelast,playerid, lgid, sum(salary)::INTEGER::MONEY as total_salary
from collegeplaying
join people
using(playerid)
join schools
using(schoolid)
join salaries
using (playerid)
where (lgid = 'NL' or lgid = 'AL')
and (schoolname = 'Vanderbilt University')
group by namefirst, namelast, playerid, lgid
order by total_salary desc;

--8. Using the attendance figures from the homegames table,
--find the teams and parks which had the top 5 average attendance
--per game in 2016 (where average attendance is defined as total
--attendance divided by number of games). Only consider parks where
--there were at least 10 games played. Report the park name, team name,
--and average attendance. Repeat for the lowest 5 average attendance.

--attendance figures for teams and parks top 5(limit 5)
--avg attendance(total attendance/number of games) per game
--where year = 2016 and parks where games played >= 10
--park name, team name, avg attendance ~> repeat for lowest 5 order by asc/limit 5

--top 5
select p.park_name, t.name, sum((h.attendance)/(h.games)) as avg_attendance
from homegames as h
join parks as p
using (park)
join teams as t
on h.team = t.teamid
where h.year = 2016
and h.games >= 10
group by p.park_name, t.name
order by avg_attendance desc
limit 5;

--bottom 5
select p.park_name, t.name, sum((h.attendance)/(h.games)) as avg_attendance
from homegames as h
join parks as p
using (park)
join teams as t
on h.team = t.teamid
where h.year = 2016
and h.games >= 10
group by p.park_name, t.name
order by avg_attendance asc
limit 5;

--11. Is there any correlation between number of wins and team salary?
--Use data from 2000 and later to answer this question.
--As you do this analysis, keep in mind that salaries across the whole
--league tend to increase together, so you may want to look on a year-by-year basis.
select*
from salaries;
select*
from teams;
--No, there does not seem to be a correlation between number of wins and team salary.
select t.w,
sum(s.salary)::NUMERIC::MONEY as team_salary,
DENSE_RANK() OVER (
        PARTITION BY s.yearid
		ORDER BY t.w desc
    )   AS year_salary_rank, s.yearid, t.name
from teams as t
join salaries as s
using(yearid, lgid, teamid)
where (s.yearid >= 2000)
and (t.lgid = 'NL' or lgid = 'AL' )
group by t.w,s.yearid,t.name;

