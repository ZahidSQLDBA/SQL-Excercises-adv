/*
we need to find second most recent activity and if user has only 1 activity then return that as it is
*/
select *
from UserActivity;
with
    windCte
    AS
    (
        select *, ROW_NUMBER() over(partition by username order by startDate desc) as rn 
, LEAD(activity,1,'0') over(partition by username order by startDate desc) as leadactivity
        from UserActivity
    )
SELECT username, activity, startDate, endDate
from windcte
where rn = 2 or (leadactivity = '0' and rn = 1)