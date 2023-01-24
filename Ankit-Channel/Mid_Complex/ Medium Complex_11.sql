/*Write a qquery to print high paid employee and low paid employee in same departmnets*/

-- Approach 1 - Using Window functions and join concepts
select *
from employee;
with
    cte1
    as
    (
        select *
, DENSE_RANK() over (PARTITION by dep_id order by salary desc) as high_sal
        from employee
    ),
    cte2
    as
    (
        select *
, DENSE_RANK() over (PARTITION by dep_id order by salary) as low_sal
        from employee
    )
select cte1.dep_id, cte1.emp_name as dep_high_sal_emp_name, cte2.emp_name as dep_low_sal_emp_name
from cte1
    join cte2
    on cte1.dep_id = cte2.dep_id and high_sal = 1 and low_sal = 1


-- Approach 2 using group by and join
with
    cte3
    AS
    
    (
        select dep_id, MAX(salary) as max_sal, MIN(salary) as min_sal
        from employee
        GROUP by dep_id
    )
select cte3.dep_id, e.emp_name as dep_high_sal_emp_name ,
    e1.emp_name as dep_low_sal_emp_name
from cte3
    join employee e
    on e.dep_id = cte3.dep_id
        and max_sal = e.salary
    join employee e1
    on e.dep_id = cte3.dep_id
        and min_sal = e1.salary 
--and min_sal = e.salary
select *
, DENSE_RANK() over (PARTITION by dep_id order by salary desc) as high_sal
, DENSE_RANK() over (PARTITION by dep_id order by salary ) as low_sal
        from employee
