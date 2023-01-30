
-- In this question we are trying to find out top score player from each group. In case of tie, the ranking of top player 
-- depends on sequqnce of player id. Smaller the player id higher the rank in case of tie.

select *
from players;
SELECT *
from matches;
with
    cte1
    as
    (
        select g1.first_player as player, sum(g1.first_score) as total_score
        from
            (                select first_player, first_score
                from matches
            union ALL
                select second_player, second_score
                from matches) g1
        GROUP by g1.first_player
    )
,
    cte2
    AS
    (
        select cte1.*, p.group_id, RANK() OVER (PARTITION by group_id order by total_score desc, player) as rank
        from cte1
            join players p
            on p.player_id = cte1.player
    )
SELECT player, group_id
from cte2
where rank = 1;
