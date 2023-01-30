/*Find how many products fall into customer budget along with list of products.
In case of clash choose the less costly product
*/
select *
from products;
select *
from customer_budget;
select *, SUM(cost) over (order by cost ) as moving_sum
from products;

with
    cte1
    AS
    
    (
        select *
, SUM(cost) over (order by cost) as moving_sum
        from products
    )
SELECT c.*, count(1) as no_of_product, STRING_AGG(product_id, ',') as list_of_product
from customer_budget c
    left join cte1
    on moving_sum < budget
group by customer_id, budget