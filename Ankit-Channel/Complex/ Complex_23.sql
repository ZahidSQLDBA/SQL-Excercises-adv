/*
find cities where covid cases are continuously increasing.
*/
select *
from covid;
with
    cte1
    as
    (
        select *
, RANK() over (partition by city order by days) as day_rank
, RANK() over (partition by city order by cases) as case_rank
, RANK() over (partition by city order by days) - RANK() over (partition by city order by cases) as diff
        from covid
    )
select city
from cte1
group by city
having max(diff) = 0 -- to see if all dii values are zeroes
    and count(distinct diff)=1