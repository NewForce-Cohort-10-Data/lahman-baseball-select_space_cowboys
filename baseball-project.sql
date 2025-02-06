--bre teammember-1 (2,6,10)
--jacob teammember-2 (3,8,11)
--cyrus teammember-3 (4,5,7)
--emily teammember-4 (9,12,13)

--1 1871 - 2016
select min(year) as earliest_year, max(year) as latest_year
from homegames;

--3. Find all players in the database who played at Vanderbilt University.
--Create a list showing each player’s first and last names as well as the total
--salary they earned in the major leagues. Sort this list in descending order by
---the total salary earned. Which Vanderbilt player earned the most money in the majors?

--players, vanderbilt university>>>first,last,totalsalary(for major leagues)>>>sort desc
--by totalsalary


select*
from homegames;
select*
from people;
select*
from schools;
select*
from salaries
where playerid = 'priceda01';
select*
from collegeplaying;
select*
from teams;

select name
from teams
where name = 'Vanderbilt University'

select namefirst, namelast, salary
from collegeplaying
join people
using(playerid)
join schools
using(schoolid)
join salaries
using (playerid)
where schoolname = 'Vanderbilt University'
group by namefirst, namelast, salary
order by salary desc;


--3. Find all players in the database who played at Vanderbilt University.
--Create a list showing each player’s first and last names as well as the total
--salary they earned in the major leagues. Sort this list in descending order by
---the total salary earned. Which Vanderbilt player earned the most money in the majors?

--players, vanderbilt university>>>first,last,totalsalary(for major leagues)>>>sort desc
--by totalsalary
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


select namefirst, namelast,playerid, lgid, sum(salary) as total_salary
from collegeplaying
join people
using(playerid)
join schools
using(schoolid)
join salaries
using (playerid)
where schoolname = 'Vanderbilt University'
group by namefirst, namelast, playerid, lgid
order by total_salary desc;