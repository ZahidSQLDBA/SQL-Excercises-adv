/*
Write a query to change the NULL values with prior NON NULL values. As soon as NON NULL value changes then NULL values
to be replaced with NON-NULL values.
*/

select *
from brands;
with
    cte1
    As
    (
        select *
, ROW_NUMBER() over (order by (select 1)) as rn
        from brands
    )
 ,
    cte2
    as
    (
        select *
 , lead (rn, 1, 99999) over (ORDER by rn) as next_rn
        from cte1
        where category is not NULL
    )

select cte2.category, cte1.brand_name
--> cte2.category beacuse it comes from cte2, in cte1 it would be NULL
from cte1
    join cte2
    on cte1.rn between cte2.rn and cte2.next_rn -1  --> The BETWEEN operator is inclusive: begin and end values are included.
 --on cte1.rn >= cte2.rn and cte1.rn < cte2.next_rn 