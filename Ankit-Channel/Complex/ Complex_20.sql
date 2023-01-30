-- update bms set is_empty = 'N' where seat_no =12;
-- update bms set is_empty = 'N' where seat_no =7;
/*
Find 3 or more consequetive seats in book my show
*/
SELECT *
FROM bms
where 
is_empty = 'Y';
with
    cte
    as
    (
        SELECT *
, LEAD(seat_no, 2) over (order by seat_no) as lead_seat_no
        --, ROW_NUMBER() over(order by is_empty)
        from bms
        where is_empty = 'Y'
    )
,
    cte2
    as
    
    (
        (select seat_no, lead_seat_no
        from cte
        where lead_seat_no - seat_no = 2
    )
)
--select * from cte2
select distinct b.seat_no
from bms b
    join cte2
    on b.seat_no between cte2.seat_no and cte2.lead_seat_no