/*
in this problem we need to get the state as start date to end date. (until point where state is same).
as state changes the new dates to be considered to form new start and end range.
in case there are no further dates available to end and start date should be same
*/


SELECT *
from tasks;
with
    basedateCte
    as
    (
        SELECT *,
            row_number() over (partition by state order by date_value) as rn
-- trick here is to get same base date by subtracting from row_number to have it created same for consequitive dates
, DATEADD(day, -1* ROW_NUMBER()over (partition by state order by date_value),date_value) as base_date
        from tasks
    )
SELECT MIN(date_value) as start_date, MAX(date_value) as end_date, state
from basedateCte
GROUP by base_date,state
ORDER by start_date;