/*Case Study of Spotify*/
select *
from activity
order by user_id, event_date;
--Q1 total activity of users each day
select event_date, count(distinct user_id) as total_active_users
from activity
GROUP by event_date;

--Q2 total active user weekly
select datepart(week, event_date) as week_number, count(distinct user_id) as total_active_users
from activity
GROUP by datepart(week, event_date);

--Q3 date wise total_number of users who purchased app and installed it on same day
--select * from activity order by user_id, event_date;
with
    cte1
    AS
    
    (
        select user_id
-- since null is ignored by max so idea is to club by user_id
, MAX(case when event_name = 'app-purchase' then event_date  end) as app_purchase_date
, MAX(case when event_name = 'app-installed' then event_date end) as app_install_date
        from activity
        group by user_id
    ),
    q1cte
    as
    
    (
        select event_date, count(distinct user_id) as total_active_users
        from activity
        GROUP by event_date
    )
,
    q4cte
    AS
    
    (
        select app_purchase_date event_date, count(1) as no_of_users
        FROM cte1
        where app_purchase_date = app_install_date
        group by app_purchase_date
    )
select q1.event_date
, case when MAX(q4.no_of_users) is null then 0 else MAX(no_of_users) end as no_of_user_same_day_pur_install
from q1cte q1
    left join q4cte q4
    on q4.event_date = q1.event_date
group by q1.event_date

--Approach 2
select
    A.event_date,
    --user_id,
    count(A.new_count) as no_of_user_same_day_pur_install
from
    (select user_id, event_date , case when count(distinct event_name)=2 then user_id else null END as new_count
    from activity
    group by user_id, event_date ) A
--GROUP BY user_id
GROUP BY event_date

--Q4 percentage of paid users in India, USA and any other country should be tagged as others
--select * from activity
select country, (COUNT(country) * 100)/MAX(cnt) as per_user
from
    (select
        case when country IN ('India','USA') then country else 'others' end as country
, COUNT(*) over (order by country ROWS BETWEEN unbounded preceding and unbounded following ) as cnt
    from activity
    where event_name = 'app-purchase') A
group by country;

--Q5 Among all the users who installed app on a given day, how many did app purchase on very next day
-- need day wise results
SELECT
    --a.user_id, 
    a.event_date,
    --b.*
    COUNT(b.user_id) as cnt_users
from activity a
    left join activity b
    on a.user_id = b.user_id
        and a.event_date = DATEADD(Day, 1, b.event_date)
GROUP by a.event_date