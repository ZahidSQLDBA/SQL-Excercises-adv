/*
write a query to find the rows from table where crowd was 100 or more for 3 or
more consequetive days
*/

select *
from stadium;
with
    cte1
    as
    (
        select *
, row_number() over (order by visit_date) as rn
, id - row_number() over (order by visit_date) as diff
        from stadium
        where no_of_people > 100
    )
,
    cte2
    as
    (
        select id, visit_date, no_of_people
, COUNT(1) over (PARTITION by diff order by diff) as cnt
        from cte1
    )
select id, visit_date, no_of_people
from cte2
where cnt >=3
-- GROUP by diff
-- having count(1) >=3
