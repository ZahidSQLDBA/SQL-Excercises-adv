/*
find product pairs most commonly brought together. Used in recommendation system to ecommerce site users.
*/
select *
from orders_q13;
SELECT *
from products_q13;

select p1.name + ' ' + p2.name as pairs, count(1) as purchase_freq
from orders_q13 o1
    inner join orders_q13 o2
    on o1.order_id = o2.order_id
        and o1.product_id < o2.product_id
    inner join products_q13 p1
    on p1.id = o1.product_id
    inner join products_q13 p2
    on p2.id = o2.product_id
GROUP by p1.name, p2.name