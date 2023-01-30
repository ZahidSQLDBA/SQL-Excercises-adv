/*
Pareto principle 80% of sales comes from 20% of top product sales.
Write a query to find top 20% high sale products - as per Pareto Principle they would 
responsible for 80% of company sales.
*/

--select product_id, sales from store_orders;

with cte1 as (
select product_id, sum(sales) as product_sales
from store_orders
GROUP by product_id)
,cte2 as (
select product_id, product_sales, 
-- running total
SUM(product_sales) over (order by product_sales desc rows between unbounded preceding and current row ) as running_sales
-- 80% of overall sale value
,(0.8 * 1.0 )* SUM(product_sales) over () as eighty_prec_sales
from cte1)
select product_id, product_sales
from cte2
where running_sales < = eighty_prec_sales;