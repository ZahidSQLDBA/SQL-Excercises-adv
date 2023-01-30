/*
Write a query to fetch repeat customer count, new customer count and revenue they generate on daily basis 
*/
select *
from customer_orders;

with
    cte1
    as
    (
        select customer_id, MIN(order_date) as first_order_date
        from customer_orders
        group by customer_id
    )
select c.order_date
, SUM(case when c.order_date = first_order_date then 1 else 0 END) as new_cust_count
, SUM(case when c.order_date != first_order_date then 1 else 0 END) as old_cust_count
, SUM(case when c.order_date = first_order_date then order_amount else 0 END) as new_cust_order_revenue
, SUM(case when c.order_date != first_order_date then order_amount else 0 END) as old_cust_order_revenue
--, STRING_AGG(c.customer_id,',') as cust_ids
from customer_orders c 
    INNER join
    cte1
    on c.customer_id = cte1.customer_id
GROUP by c.order_date
