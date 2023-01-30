-- Find the 3rd Highest salary for employees from each department. 
-- In case the employess are less than 3 in any department then return lowest salary
select *
from emp;
with
    cte
    as
    (
        select *
, RANK() over (partition by dep_id order by salary desc) as rn
, count(1) over (partition by dep_id) as emp_dep_cnt
        from emp
    )
select *
from cte
-- any of the WHERE works.
where rn = case when emp_dep_cnt >= 3 then 3 else emp_dep_cnt end
--where rn = 3 or (emp_dep_cnt < 3 and rn = emp_dep_cnt)
