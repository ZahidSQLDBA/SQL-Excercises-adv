-- write a query to determine which user visited which floor most, total number of visits and aggregated resources
-- sperated by ','.
select *
from entries;
with
    cte
    as
    (
        select name, floor
        , rank() over (partition by name order by count(1) desc) as rn
        from entries
        group by name, floor
    )

,
    cte2
    as
    (
        select cte.name
, cte.floor as most_visted_floor
, count(cte.name) as total_visits
, resources
        from cte
            join entries e
            on e.name = cte.name
                and rn = 1
        group by cte.name, cte.floor, resources
    )

select name, max(most_visted_floor) as most_visted_floor 
, sum(total_visits) as total_visits
, STRING_AGG(resources,',') as resources_used
from cte2
group by name;
