/*
find total no. of messages exchanged between each person per day.
*/
select *
from subscriber;
with
    cte1
    as
    (
        select sms_date
, case when sender < receiver then sender else receiver end as sender
, case when sender > receiver then sender else receiver END as receiver
, sms_no
        from subscriber
    )
select sms_date, sender, receiver , SUM(sms_no) as total_sms_exchanged
from cte1
group by sms_date, sender, receiver

-- select * from subscriber;
-- select *, 
-- ROW_NUMBER() over (PARTITION by 
--           case when sender < receiver then sender else receiver end
--          ,case when sender > receiver then sender else receiver END
--           order by sms_date) as rn
-- from subscriber;