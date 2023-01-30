-- Find the cancellation rate of rides by unbanned users per day.
-- Cancellation rate for unbanned user = cancelled ride/total number of rides 

SELECT *
from trips;
SELECT *
from users
where banned = 'No';
with
    cte1
    as
    (
        select client_id, driver_id,
            case when status like 'cancelled%' then 1 else 0 END as can_rate,
            request_at
        from trips
        where client_id in (select users_id
            from users
            where banned = 'No')
            and driver_id in (select users_id
            from users
            where banned = 'No')
    )
select request_at, ROUND((SUM(can_rate) * 1.0)/count(1),2,1)
from cte1
GROUP by request_at

-- Another way to remove banned driver/users using join
select client_id, driver_id, u1.banned, u.banned, status, request_at
from trips t
    join users u
    on u.users_id = t.client_id
    join users u1
    on u1.users_id = t.driver_id
where u1.banned = 'No' and u.banned = 'No'