/*
find missing quarter for each store
*/

--meth 1 Recursive CTE
SELECT *
from STORES;
with
    cte_1
    as
    (
                    select distinct store, 1 as q_no
            from stores
        union ALL
            SELECT store, q_no+1
            from cte_1
            where q_no < 4
    )
--select * from cte_1 order by store
,
    cte2
    as
    (
        Select store,
            cast('Q' + cast(q_no as varchar(2)) as VARCHAR(2)) as qtr
        from cte_1
    )
SELECT cte2.*
from cte2
    LEFT JOIN
    STORES s
    on cte2.qtr = s.Quarter
        and s.store = cte2.store
where s.store is NULL

-- meth 2 Aggregate
SELECT *
from STORES;
select store, 10-SUM(cast(right(quarter,1) as int)) as miss_qtr
from stores
GROUP by store;

-- meth 3 CROSS JOIN
with
    cte1
    as
    (
        select distinct s1.store, s2.QUARTER
        from stores s1
cross JOIN stores s2
    )
select cte1.*
from cte1
    left join stores s
    on cte1.store = s.store
        and cte1.quarter = s.quarter
where s.store is null