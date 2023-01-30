/*
Write a SQL to determine phone numbers that satisfy below conditions
1. the numbers have both incoming and outgoing calls
2. sum of duration of outgoing calls should be > sum of duration of incoming calls
*/

-- approach 1
select *
from call_details
order by call_number;
select call_number
-- ,sum(inc_call_dur), sum(out_call_dur) -- (optional fields)
from
    (select call_type, call_number
, case when call_type = 'INC' then call_duration end as inc_call_dur
, case when call_type = 'OUT' then call_duration end as out_call_dur
    from call_details
    where call_type in ('INC', 'OUT')) a
GROUP by call_number
having count(distinct call_type) > 1
    and sum(out_call_dur) > sum(inc_call_dur);

-- Approach 2
with
    cte
    as
    (
        select call_number
, SUM(case when call_type = 'INC' then call_duration end) as inc_call_dur
, SUM(case when call_type = 'OUT' then call_duration end) as out_call_dur
        from call_details
        where call_type in ('INC', 'OUT')
        group by call_number
    )
select call_number
from cte
where out_call_dur > inc_call_dur
    and out_call_dur is not null and inc_call_dur is not NULL;

--Approach 3
with
    incCte
    as
    (
        select call_number
, SUM(case when call_type = 'INC' then call_duration end) as call_dur
        from call_details
        where call_type in ('INC')
        group by call_number
    )
,
    outCte
    as
    (
        select call_number
, SUM(case when call_type = 'OUT' then call_duration end) as call_dur
        from call_details
        where call_type in ('OUT')
        group by call_number
    )
select i.call_number
from incCte i
    join outCte o
    on o.call_dur > i.call_dur
        and i.call_number = o.call_number

-- select distinct cd1.*,cd2.*
-- --COUNT(1) over (PARTITION by call_number order by call_number)
-- from call_details cd1
-- join call_details cd2
-- on cd1.call_number = cd2.call_number
-- and cd1.call_type = 'INC' and cd2.call_type = 'OUT'
-- --where call_type in ('OUT', 'INC')