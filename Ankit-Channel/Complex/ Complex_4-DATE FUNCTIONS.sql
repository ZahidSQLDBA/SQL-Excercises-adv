--DECLARE VARS
declare @n INT;
declare @today_date date
declare @begin_date date
declare @end_date date
set @n = 10;
set @today_date = '2023-01-09';
set @begin_date = @today_date;
set @end_date = DATEADD(DAY, @n, @today_date)



-- EXPLANATION:
/*DATEPART(DW,@today_date)       --> gives day of week of @today_date
using DATEADD add number of days --> reason for subtracting with 8 is it counts a day after excluding current date pointer
to find immediate sunday
now agian wrap it up with DATEADD to find remaining @n-1 SUNDAYS as 1 SAUNDAY was already determined.
*/

--QUERY: to find @nth 'Sunday' occurence
select DATEADD(DAY, (@n-1) * 7,DATEADD(DAY,(8 - DATEPART(DW,@today_date)),@today_date));

-- Resuable query to increase today's date by given business days. Business days exclude Saturday and Sunday
-- Ofcourse we can get rid CTE and use CTE part directly in query.
with
    cte1
    AS
    (
        SELECT @today_date as today_date
, DATEPART(WEEK, @today_date) as begin_week
, DATEPART(WEEK, DATEADD(DAY,@n, @today_date)) as end_week
    )
SELECT today_date, @n as add_num_of_days
, case when begin_week = end_week then DATEADD(DAY, @n ,@today_date)       -- In case beign and end date belong to same WEEK
   else DATEADD(DAY, 2 * (end_week - begin_week) + @n ,@today_date) end as next_bus_day
, case when begin_week = end_week then DATENAME(WEEKDAY, DATEADD(DAY, @n ,@today_date))  -- In case beign and end date belong to same WEEK
   else DATENAME(WEEKDAY, DATEADD(DAY, 2 * (end_week - begin_week) + @n ,@today_date)) end as next_bus_day_name
from cte1

-- Query to find actual business difference (exclude saturday and sunday)
SELECT DATEDIFF(DAY, @begin_date, @end_date) - 2 * ((DATEPART(week, @end_date)) - (DATEPART(week, @begin_date)))
    as no_of_bus_days


