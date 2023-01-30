/* User purchase platform.
-- The table logs the spendings history of users that make purchases from an online shopping website which has a desktop 
and a mobile application.
-- Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only 
and both mobile and desktop together for each date.
*/
SELECT *
from spending;

with
    cte1
    AS
    (
        select user_id, spend_date, amount, platform, count(1) over (PARTITION by user_id, spend_date) as cnt
        from spending
    )
,
    cte2
    as
    
    (
        select case when cnt = 2 then 'both' else platform END as platform, user_id, amount, spend_date
        from cte1
    )
select spend_date, platform, sum(amount) as amount, COUNT(distinct(user_id)) as no_of_users
from cte2
group by platform, spend_date
