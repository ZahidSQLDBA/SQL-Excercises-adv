/*
total charges as per billing rate for SCD2 type data.
*/
Select *
from billings;
Select *
from HoursWorked;
with
    cte1
    AS
    
    (
        select emp_name,
            bill_date, bill_rate,
            LEAD(dateadd(day, -1, bill_date), 1, '9999-12-31') over(PARTITION by emp_name order by bill_date) as bill_end_date
        from billings
    )
SELECT cte1.emp_name, SUM(cte1.bill_rate * h.bill_hrs) as billing
from cte1
    join HoursWorked h
    on h.emp_name = cte1.emp_name
        and work_date BETWEEN cte1.bill_date and cte1.bill_end_date
GROUP by cte1.emp_name
-- select h.emp_name
--  ,h.work_date,b.bill_date
-- ,h.bill_hrs, b.bill_rate as billing
-- from HoursWorked h
-- join billings b
-- on h.emp_name = b.emp_name
-- and year(h.work_date) >= year(b.bill_date)
--group by h.emp_name