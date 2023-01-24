/*
In this problem we will learn how to convert comma separated values into row.
*/

select *
from airbnb_searches;

select value as room_type, count(1) as no_of_searches
from airbnb_searches
cross APPLY string_split(filter_room_types,',')
group by value
order by no_of_searches DESC
-- WITH r_cte AS
-- (
--     SELECT user_id, date_searched, 
-- left (filter_room_types, CHARINDEX(',', filter_room_types + ',') -1) as dataItem,
-- STUFF(filter_room_types,1,CHARINDEX(',',filter_room_types + ','), '') as filter_room_types
-- from airbnb_searches
-- union ALL
--     SELECT user_id, date_searched, 
-- left (filter_room_types, CHARINDEX(',', filter_room_types + ',') -1) as dataItem,
-- STUFF(filter_room_types,1,CHARINDEX(',',filter_room_types + ','), '') as filter_room_types
-- from r_cte
-- where filter_room_types > ''
-- )
-- SELECT * from r_cte;