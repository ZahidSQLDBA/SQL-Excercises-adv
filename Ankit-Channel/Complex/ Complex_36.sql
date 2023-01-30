/*
there are  theree rows in movie hall. Write a query to find >3 consequetive rows in each
rows
*/

select *
from movie;
with
    row_assign
    as
    (
        select seat
, left(seat,1) as char_seat
, CAST(substring(seat,2,LEN(seat)) as INT) as numeric_seat
, occupancy
, ROW_NUMBER() over (partition by left(seat,1) 
              order by CAST(substring(seat,2,LEN(seat)) as int)) as rn
        from movie
    )
,
    empty_seats
    as
    (
        select seat, numeric_seat, char_seat
, CASE 
  when (numeric_seat - row_number() over (order by char_seat,numeric_seat)) < 0 
    then (numeric_seat - row_number() over (order by char_seat,numeric_seat)) * -1 
  else numeric_seat - row_number() over (order by char_seat,numeric_seat) 
  END as new_rn
        from row_assign
        where occupancy = 0
    )
,
    cntcte
    as
    (
        select *
, count(new_rn) over (partition by char_seat, new_rn ) as cnt
        from empty_seats
    )

select seat
from cntcte
where cnt > 3

-- TO have results in comma seprated -- 
--  select STRING_AGG(seat,',')
-- from empty_seats 
-- group by left(seat,1),new_rn
-- having count(1) > 3
