/*
Given the following two tables, return the fraction of users, rounded to two decimal places,
who accessed Amazon music and upgraded to prime membership within the first 30 days of signing up. 
*/
select *
from users_q15;
select *
from events_q15;
with
    cte1
    as
    (
        select name, join_date, type, access_date
, lead(type, 1,'0') OVER (partition by name ORDER by access_date) as lead_type
, lead(access_date, 1) OVER (partition by name ORDER by access_date) as lead_date
        from users_q15 u
            inner join events_q15 e
            on u.user_id = e.user_id
                and e.type in ('P', 'Music')
                and access_date > join_date
    )

,
    cte2
    AS
    (
        select name, join_date AS amazon_signup_date
, access_date as music_subscription_date,
            lead_date as prime_subscription_date 
, count(1) over (order by name rows BETWEEN unbounded preceding and unbounded following) as prime_subscribed_count
        from cte1
        where type = 'Music' and lead_type = 'P'
            and DATEDIFF(Day, join_date,lead_date) <=30
    )

,
    cte3
    AS
    
    (
        select name, COUNT(1) over (order by name rows BETWEEN unbounded preceding and unbounded following) as total_music_subs
        from cte1
        where type = 'Music'
    )

select cte2.name, ((prime_subscribed_count * 1.0)/total_music_subs)*100 as fraction
from cte2 join cte3
    on cte2.name = cte3.name;
--group by u.name
--select
--ORDER by name;

