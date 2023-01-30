/*
find the largest order by value for each sales person and display order details
without using cte, subqery, window function, temp tables
*/
select *
from int_orders;
select o1.order_number, o1.salesperson_id, o1.amount
from int_orders o1
    left join int_orders o2 on o1.salesperson_id = o2.salesperson_id
GROUP by o1.order_number, o1.salesperson_id, o1.amount
having o1.amount >= MAX(o2.amount)
