/*
Write a SQL query to find the users who have not purchase repeated products over given period of time
MEANS the products bought should not match for any day !
*/

select *
from purchase_history;

-- Approach 1 - Just Aggregation
select userid
from purchase_history
group BY userid
having count(distinct purchasedate) > 1
    and count(distinct productid) = count(1);

-- Approach 2 Window function + Aggregation
with cte1 as (
SELECT *
,RANK()OVER(PARTITION BY userid,productid ORDER BY purchasedate) AS rnk
FROM purchase_history)
SELECT userid
FROM cte1
GROUP BY userid
HAVING max(rnk)=1 AND count(distinct purchasedate)>1