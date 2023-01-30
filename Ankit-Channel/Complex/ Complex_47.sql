/*
Find the total number of rides and profit rides for each driver
Profit ride means end ride location is start location of next ride
*/

-- Approach 1 -> Using Window functions
select *
from drivers;
with
    cte1
    as
    (
        select *
, lead(start_loc) over (partition by id order by start_time) as next_ride
, count(1) over (PARTITION by id) as total_rides
        from drivers
    )
select id, total_rides,
    sum(case when next_ride = end_loc then 1 else 0 end) as profit_ride
-- count(1) as profit_rides
from cte1
-- where end_loc = next_ride  --> this apprach would give ONLY drivers who had profit rides
GROUP by id,total_rides;

-- Approach 2 - Self join, you can also generate ROW_NUMBER() as explained in video 
-- and solve it. 
select d1.id
, COUNT(1) as total_rides
, SUM(case when d2.id is null then 0 else 1 end) as profit_rides
from drivers d1
    left join drivers d2
    on d1.start_loc = d2.end_loc
        and d2.end_time between d1.start_time and d1.end_time
        and d1.id = d2.id
group by d1.id

