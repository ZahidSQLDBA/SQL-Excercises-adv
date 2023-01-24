/*
try to find out total number of people inside hospital
*/
SELECT *
from hospital;
with
    cte1
    as
    (
        select *, LEAD(action, 1,0) OVER (PARTITION by emp_id order by time) as lead_action
        from hospital
    )

select count(*) total_emp_inside
from cte1
where action = 'in' and lead_action = '0';