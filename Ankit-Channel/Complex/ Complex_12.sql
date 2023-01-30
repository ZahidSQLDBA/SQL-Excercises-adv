/*
in this probelm we are trying to find year by sales of different product using recursive cte.
*/
select *
from sales;
with
    rcte
    as
    (
                    select MIN(period_start) as s_date , max(period_end) as end_date
            from sales
        UNION ALL
            SELECT DATEADD(DAY,1,s_date), end_date
            from rcte
            where s_date < end_date
    )
--select * from rcte

select product_id, year(s_date) as years,
    --period_start, period_end, 
    sum(average_daily_sales) as total_sales_by_year
from rcte
    join sales on s_date BETWEEN period_start and period_end
group by product_id, year(s_date)
order by product_id, year(s_date)
option(
MAXrecursion
1000);