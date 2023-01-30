/*
Write a query to find the details of caller/recipient id who are having 
first and last call for the given day.
*/
select * from phonelog;
with cte as (
select callerid, recipientId, DATEADD(dd, 0, DATEDIFF(dd, 0, datecalled)) as dt_of_call
,ROW_NUMBER() over(PARTITION by CallerId,DATEADD(dd, 0, DATEDIFF(dd, 0, datecalled)) order by DATEADD(dd, 0, DATEDIFF(dd, 0, datecalled))) as rn
,count(1) over(PARTITION by CallerId,DATEADD(dd, 0, DATEDIFF(dd, 0, datecalled)) order by DATEADD(dd, 0, DATEDIFF(dd, 0, datecalled))) as cnt
from phonelog
)
SELECT callerid, recipientId, dt_of_call
-- callerid, recipientId, datecalled 
from cte
where rn = 1 or rn = cnt
group by callerid, recipientId, dt_of_call
HAVING COUNT(1) > 1
-- select Callerid
-- , RecipientID
-- , MIN(Datecalled) as min_time
-- , Max(datecalled) as max_time
-- from phonelog
-- group by Callerid
-- , RecipientID, Datecalled

-- select CallerId, Recipientid, count(1)
-- from phonelog
-- group by CallerId, Recipientid, DATEADD(dd, 0, DATEDIFF(dd, 0, datecalled))