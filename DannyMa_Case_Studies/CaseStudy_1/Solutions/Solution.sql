SELECT *
FROM dannys_diner.members;

SELECT *
FROM dannys_diner.menu;

SELECT *
FROM dannys_diner.sales;

-- #Q1 What is the total amount each customer spent at the restaurant?
select customer_id 
, SUM(m.price) as total_spent_amount
from dannys_diner.sales s
join dannys_diner.menu m on s.product_id = m.product_id
group by customer_id;

-- Q2 How many days has each customer visited the restaurant?
select customer_id
,count(distinct order_date) as days_each_cust_visitied
from dannys_diner.sales
group by customer_id;

-- Q3 What was the first item from the menu purchased by each customer?
with CTE1 as (
select customer_id, MIN(order_date) as first_order_date
from dannys_diner.sales
group BY customer_id
)
select distinct cte1.customer_id, m.product_name
from CTE1
join dannys_diner.sales s on s.order_date = cte1.first_order_date
and s.customer_id = CTE1.customer_id
join dannys_diner.menu m on m.product_id = s.product_id;

-- Q4 What is the most purchased item on the menu and how many times was it purchased by all customers?
with agg_cte AS (
    select product_id, count(product_id) as times_ordered
    from dannys_diner.sales
    group BY product_id
)
SELECT TOP 1 m.product_name, agg_cte.times_ordered
from agg_cte
join dannys_diner.menu m on m.product_id = agg_cte.product_id
ORDER by agg_cte.times_ordered DESC;

-- Q5 Which item was the most popular for each customer?
with popular_cte as (
select customer_id, product_id
,RANK() over (PARTITION by customer_id order by count(product_id) desc) as rnk
from dannys_diner.sales
group by customer_id, product_id
)
select popular_cte.customer_id, m.product_name
from popular_cte
join dannys_diner.menu m on m.product_id = popular_cte.product_id
where rnk = 1;

-- Q6 Which item was purchased first by the customer after they became a member?

with member_cte as (
select s.customer_id as customer_id, s.product_id as product_id
,RANK() over (PARTITION by s.customer_id order by s.order_date) as order_rank
from dannys_diner.sales s
join dannys_diner.members m on m.customer_id = s.customer_id and s.order_date >= m.join_date 
)
SELECT member_cte.customer_id, m.product_name
from member_cte 
join dannys_diner.menu m on m.product_id = member_cte.product_id
where  order_rank = 1;

-- Q7 Which item was purchased just before the customer became a member?
with bef_member_cte as (
select s.customer_id as customer_id, s.product_id as product_id
,RANK() over (PARTITION by s.customer_id order by s.order_date desc) as order_rank
from dannys_diner.sales s
join dannys_diner.members m on m.customer_id = s.customer_id and s.order_date < m.join_date 
)
SELECT bef_member_cte.customer_id, m.product_name
from bef_member_cte 
join dannys_diner.menu m on m.product_id = bef_member_cte.product_id
where  order_rank = 1;

-- Q8 What is the total items and amount spent for each member before they became a member?
with bef_member_cte_1 as (
select s.customer_id as customer_id, s.product_id as product_id
from dannys_diner.sales s
join dannys_diner.members m on m.customer_id = s.customer_id and s.order_date < m.join_date 
)

SELECT bef_member_cte_1.customer_id
, count(distinct bef_member_cte_1.product_id)  as total_items
, sum(m.price) as amount_spent
from bef_member_cte_1
join dannys_diner.menu m on m.product_id = bef_member_cte_1.product_id
group by bef_member_cte_1.customer_id;

-- Q9 If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
with points_cte as (
select s.customer_id
,s.product_id
,case when m.product_id = 1 then (2 * m.price * 10) else (10 * m.price) end as points
from dannys_diner.sales s
join dannys_diner.menu m on m.product_id = s.product_id
)
select points_cte.customer_id, sum(points_cte.points) as total_points
from points_cte
group by points_cte.customer_id;

-- Q10 In the first week after a customer joins the program (including their join date) 
-- they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
-- with points_member_cte as (
select s.customer_id as customer_id
,SUM(case 
     when s.order_date < m.join_date and me.product_id = 1 then (2 * 10 * me.price)
     when s.order_date < m.join_date and me.product_id != 1 then (10 * me.price) 
     when s.order_date >= m.join_date and DATEDIFF(DAY,m.join_date, s.order_date) < 6 then (20 * me.price)
     when s.order_date > m.join_date and DATEDIFF(DAY,m.join_date, s.order_date) > 6 and s.product_id != 1 then (10 * me.price)
     when ((s.order_date > m.join_date) and (DATEDIFF(DAY,m.join_date, s.order_date) > 6) and (s.product_id = 1)) then (20 * me.price)
     END) as total_points
from dannys_diner.sales s
join dannys_diner.members m on m.customer_id = s.customer_id
join dannys_diner.menu me on me.product_id = s.product_id
where s.order_date <= '2021-01-31'
group by s.customer_id;

-- BONUS QUESTIONS
-- Danny needs a flag to identify the customer was part of loyalty program or not

select s.customer_id as customer_id
,s.order_Date
,me.product_name
,me.price
,case when s.order_date >= m.join_date then 'Y' else 'N' END as member
from dannys_diner.sales s
left join dannys_diner.members m on m.customer_id = s.customer_id
join dannys_diner.menu me on me.product_id = s.product_id;

-- Danny also requires further information about the ranking of customer products, 
-- but he purposely does not need the ranking for non-member purchases 
-- so he expects null ranking values for the records when customers are not yet part of the loyalty program.

with mem_cte as (
    select s.customer_id as customer_id
,s.order_Date
,me.product_name
,me.price
,case when s.order_date >= m.join_date then 'Y' else 'N' END as member
from dannys_diner.sales s
left join dannys_diner.members m on m.customer_id = s.customer_id
join dannys_diner.menu me on me.product_id = s.product_id
)
select *
,'null' as ranking
from mem_cte
where member = 'N'
UNION ALL
select *
,CAST(dense_rank() over (PARTITION by customer_id order by order_date) AS varchar(1)) as ranking
from mem_cte
where member = 'Y'
order by customer_id, order_date