select *
from transactions;

with
    cte1
    AS
    
    (
        SELECT cust_id, month(order_date) as order_month, order_date
--ROW_NUMBER() over (PARTITION BY cust_id order by order_date) as rn
, lag(order_date,1)  over (PARTITION BY cust_id order by order_date) as lag_date
        from transactions
    )
-- retention code is commented to get churn count. Uncomment and remove cust_id from select and remove CTE from it. 
-- query then gives you retention cust count.
,retentionCte AS(
    SELECT cust_id,
    order_month as months
    --,count(1) as retention_count
    from cte1
    WHERE lag_date is not NULL
   -- GROUP by order_month
--UNION
   -- select 1, 0 
)
-- churn 
select max(a.rn) as no_of_churn_cust from
(select t.cust_id,ROW_NUMBER() OVER(order by t.cust_id) as rn
from transactions t
left join retentionCte r 
on r.cust_id = t.cust_id
where r.months is NULL
and month(order_date) = 1) a
-- SELECT month(t.order_date) as months, count(month(t.order_date))
-- from cte1
-- right JOIN cte1 t 
-- on MONTH(t.order_date) = order_month
-- WHERE lag_date is not NULL
-- GROUP by order_month


--GROUP by month(order_date)

