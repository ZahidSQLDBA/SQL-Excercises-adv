/*
in this problem we are trying to do market analysis to find if the second product sold by seller is his favorite
product or not. If yes then output the seller id with Yes (second_fav_brand) if not then No.
Also, in case seller is selling only 1 item or NO ITEM then also the o/p (second_fav_brand) should be No.
*/

-- inserted/updated certain values in table to test use cases

--insert into orders values (1,'2019-08-05',4,1,2)
--  update orders 
--  set order_id = 7 where order_date = '2019-08-06'
--   insert into users_q9 values (5,'2019-01-31','Apple');
--   insert into items values (5,'Apple');

select *
from orders;
select *
from users_q9;
select *
from items;
with
    cte1
    AS
    (
        select *,
            ROW_NUMBER() over (PARTITION by seller_id ORDER BY order_date) as rn
        from orders
    )
,
    cte2
    AS
    (
        SELECT u.user_id, cte1.*, u.favorite_brand
        , i.item_brand
        from users_q9 u
            left join cte1
            -- filtering before join
            on u.user_id = cte1.seller_id and rn = 2
            left join items i
            on i.item_id = cte1.item_id
    )
select user_id as seller_id,
    case when item_brand = favorite_brand
then 'Yes' else 'No' END as second_item_fav_brand
from cte2