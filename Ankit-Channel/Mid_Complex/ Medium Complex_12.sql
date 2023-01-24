/*
Write a query to find the time of calls of various phone numbers. Note that time entries can be more than 1 per user so
time difference needs to be considered accordingly.
*/
select *
from call_start_logs;
select *
from call_end_logs;
with
    cte1
    AS
    
    (
        select *, 
        lead(start_time,1,'9999-12-31 00:00:00.000') over (PARTITION by phone_number order by start_time) as lead_start_time
        from call_start_logs
    )

select cte1.phone_number, start_time, end_time,
    datediff(MINUTE,start_time, end_time) as time_diff
from call_end_logs e
    join cte1
    on e.phone_number = cte1.phone_number
        and end_time between start_time and lead_start_time