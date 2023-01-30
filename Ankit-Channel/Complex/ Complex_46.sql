/* Actual Table Create/Insert
   create table tbl_orders (
   order_id integer,
   order_date date
   );
   insert into tbl_orders
   values (1,'2022-10-21'),(2,'2022-10-22'),
   (3,'2022-10-25'),(4,'2022-10-25');
*/

/* Snapshot copy of table
    select * into tbl_orders_copy from  tbl_orders;
*/

/* To test Insert Delta
    select * from tbl_orders;
    insert into tbl_orders
    values (5,'2022-10-26'),(6,'2022-10-26');
*/

/* To test delete Delta  
    delete from tbl_orders where order_id=1;
*/

select *
from tbl_orders;
select *
from tbl_orders_copy;

select
  -- if t.order is null --> COALESCE will substitute it with tc.order_id
 coalesce(t.order_id, tc.order_id) 
           -- or alternatively we could also use CASE WHEN for same --
 -- case when t.order_id is null then tc.order_id else t.order_id end as order_id
 ,case when t.order_id is not null then 'I' else 'D' end as type_of_rec
    /* if needed we can build order_date like below
 ,case when t.order_date is null then tc.order_date else t.order_date end as order_date
    */

from tbl_orders t
    full OUTER join
    tbl_orders_copy tc
    on tc.order_id = t.order_id
WHERE tc.order_id is NULL or t.ORDER_id is NULL