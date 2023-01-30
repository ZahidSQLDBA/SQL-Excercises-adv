select * from sachin_score;
/*
Write a query to fetch milestone runs details for Player 'Sachin' like what was innings macth number 
when miletsone runs was 1000, 5000, 10000 ... so on 
*/

declare @milestone INT;
SET @milestone = 15000;

-- rollig sum CTE
with cte1 as (
select match, innings, runs
,SUM(runs) over (order by match) as running_score
from sachin_score
)
-- cte to generate milestone runs in order of 1000, 5000, 10000.. so on
-- user needs to provide milestone value he/she interested in.
,cte2(n) as (
    select 1000 as n 
    union ALL
    select case when (n = 1000) then (n + 4000) else (n + 5000) end as n 
    from cte2
    where n < @milestone
)
select n as milestone_runs
,min(match) milestone_match
,min(innings) milestone_innings
from cte2
join cte1
on running_score > n
group by n