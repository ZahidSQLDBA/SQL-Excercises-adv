/* From table write query to find out how many matches team played and how many they won and how many lost as separate 
columns
*/
select *
from icc_world_cup;
with
    cte
    as
    (
                    select team_1, case when team_1 = Winner then 1 else 0 end as win_flag
            from icc_world_cup
        union ALL
            select team_2, case when team_2 = Winner then 1 else 0 end as win_flag
            from icc_world_cup
    )

select team_1 as team_name
, count(1) as matches_played
, SUM(win_flag) as no_of_wins
, COUNT(1) - SUM(win_flag) as no_of_losses
from cte
group by team_1
order by no_of_win desc


-- Appoach 2

--  ,cte2 AS (
-- select team_1
-- ,case when win_flag = 1 then sum(win_flag) else 0 end as no_of_win
-- ,SUM(case when win_flag = 0 then 1 else 0 end) as no_of_loss
--  from cte
--  group by team_1, win_flag
-- )

--  select team_1 as team_name,  max(no_of_win) + max(no_of_loss) as match_played
--  , max(no_of_win) as no_of_wins
--  , max(no_of_loss) as no_of_losses
--  from cte2
--  group by team_1