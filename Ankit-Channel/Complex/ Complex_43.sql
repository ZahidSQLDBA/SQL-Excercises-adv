/*
Write SQL query to to identify the manager and senior manager of employees
Senior manager is manager of manager 
*/

--- 2 APPOACHES -----

select *
from emp;

/* First is recusrion way, where we are setting one of manager-ID as NULL for anchor query*/
UPDATE emp
set manager_id = Null
where emp_name = 'Mudit';

with
    cte1
    as
    (
                    select emp_id, emp_name, manager_id, manager_id as s_manager
            from emp
            where manager_id is NULL
        UNION ALL
            select e.emp_id, e.emp_name, e.manager_id, e1.manager_id as s_manager
            from emp e
                join cte1 c
                on c.emp_id = e.manager_id
                join emp e1
                on e1.emp_id = e.manager_id
    )
select cte1.emp_id, cte1.emp_name
, case when cte1.manager_id is null then 'No further Manager' else e1.emp_name END as manager_name
, case when cte1.s_manager is null then 'No further Manager' else e2.emp_name  END as s_manager_name
from cte1
    left join emp e1
    on e1.emp_id = cte1.manager_id
    left join emp e2
    on e2.emp_id = cte1.s_manager;

-- WAY2
/*This is self join way to get same result. Updating manager_id back to same */

UPDATE emp
set manager_id = 6
where emp_name = 'Mudit';

select
    em1.emp_id, em1.emp_name
, em2.emp_name as manager_name
, em3.emp_name as s_manager_name
from emp em1
    left join emp em2
    on em2.emp_id = em1.manager_id
    left join emp em3
    on em3.emp_id = em2.manager_id;