-- create table photoshop (
--     customer_id INT,
--     product varchar(50),
--     revenue INT
-- )
-- INSERT INTO photoshop VALUES(123,'Photoshop',50)
-- INSERT INTO photoshop VALUES(123,'Premier Pro',100)
-- INSERT INTO photoshop VALUES(123,'After Affects',50)
-- INSERT INTO photoshop VALUES(234,'Illustrator',200)
-- INSERT INTO photoshop VALUES(123,'Premier Pro',100)
-- INSERT INTO photoshop VALUES(562,'Illustrator',200)
-- INSERT INTO photoshop VALUES(913,'Photoshop',50)
-- INSERT INTO photoshop VALUES(913,'Premier Pro',100)
-- INSERT INTO photoshop VALUES(913,'Illustrator',200)

/*
We are trying to find the customer revenue for customers who have bought photoshop. The total revenue should not include 
photshop
*/

select *
from photoshop;

-- Way 1 - Using Inner JOIN and CTE
with
    CTe1
    AS

    (
        SELECT customer_id, product, case when product = 'Photoshop' then 0 else revenue end as revenues
        from photoshop
    )
select c.customer_id, sum(c.revenues) as revenue
from CTe1 c
    inner join photoshop p
    on p.customer_id = c.customer_id
        and p.product = 'Photoshop'
GROUP by c.customer_id

-- Way 2 - Using IN
SELECT customer_id,
    SUM(case when product = 'Photoshop' then 0 else revenue end) as revenue
from photoshop
where customer_id IN (select customer_id
from photoshop
where product = 'Photoshop')
group by customer_id

-- Way3 - Using Exists
SELECT customer_id
, SUM(case when product = 'Photoshop' then 0 else revenue end) as revenue
from photoshop p1
where Exists(select 1
from photoshop p2
where product = 'Photoshop' and p1.customer_id = p2.customer_id )
group by customer_id
