select *
from event_status;
with
    cte
    As
    (
        select *
, SUM(case when status = 'on' and lag_status = 'off' then 1 else 0 end) over (order by event_time) as group_key
        from
            (
select *
, LAG(status,1,status) over(order by event_time) as lag_status
            from event_status
) A
    )
select MIN(event_time) as log_in, MAX(event_time) as log_out, count(1) -1 as count
from cte
GROUP by group_key