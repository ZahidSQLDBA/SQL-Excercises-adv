/* 
Find the emplyees which a company can hire in budget of 70K with below constraints
1) Hire all seniors with lower salary in above budget
2) once seniors are hired use remaining budget to hire juniors with low salary
*/
declare @budget int;
set @budget = 70000;

select *
from candidates;

with
    cte1
    as
    (
        select *
   /* rows between unbounded preceding and current row --> avoids duplicate row problems
    which is being used as ORDER BY */
, SUM(salary) over (partition by experience order by salary rows between unbounded preceding and current row) as rolling_sum_sal
        from candidates
    )
,
    cte2
    AS
    
    (
        select *
        from cte1
        where experience = 'Senior' and rolling_sum_sal < @budget
    )
    select *
    from cte1
    where experience = 'Junior' and rolling_sum_sal < (select sum(salary)
        from cte2)
UNION ALL
    select *
    from cte2