-- write a SQl query to find all employees whose salary is same in same department
select *
from emp_salary;
-- inner join way
select e1.emp_id, e1.name, e1.salary, e1.dept_id
from emp_salary e1
    join emp_salary e2
    on e1.dept_id = e2.dept_id and e1.salary = e2.salary
        and e1.emp_id != e2.emp_id
ORDER by e1.dept_id

-- left join way
select e1.emp_id, e1.name, e1.salary, e1.dept_id
from emp_salary e1
    left join emp_salary e2
    on e1.dept_id = e2.dept_id and e1.salary = e2.salary
        and e1.emp_id != e2.emp_id
where e2.emp_id is not NULL
ORDER by e1.dept_id

