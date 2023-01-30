-- SQL Query to find median salary for each company.
--- Remember in median data needs to be sorted ASC for which you want to find median
select *
from employee_q31;
with
    cte
    as
    (
        select *
, ROW_NUMBER() over (PARTITION by company order by salary) as rn
, COUNT(company) over (PARTITION by company)  as cnt
        from employee_q31
    )
select company, AVG(salary) as median_salary
from cte
where rn between cnt * 1.0 /2 and cnt * 1.0/2 + 1
GROUP by company

-- Approach 2 but big

-- ,cte2 as (
-- select  company, salary 
-- from cte
-- where rn = case when (cnt%2 = 0) then cnt/2 else (cnt + 1)/2 end
-- union all
-- select  company, salary 
-- from cte
-- where rn = case when (cnt%2 = 0) then (cnt/2 + 1) end
-- )
-- select company, avg(salary) as median_salary
-- from cte2 
-- group by company