/*
Write a qury to tell how many unique country campaign is started by Udaan every year
*/
select *
from business_city;
with
    cte1
    AS
    (
        select DATEPART(year, business_date) as yr
, city_id
, ROW_NUMBER() over (PARTITION by city_id order by DATEPART(year, business_date)) as rn
        from business_city
    )
select yr, count(1) as #new_cities
from cte1
where rn = 1
group by yr



