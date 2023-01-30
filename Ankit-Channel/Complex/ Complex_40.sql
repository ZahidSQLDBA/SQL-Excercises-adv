/*
Write a query to fetch list of quite students.
Quite Students are who have given atleast 1 exam and have neither scored lowest or highest
for the given exam_id
Also ignore students who have not given any exam
*/

select *
from students_q_40;
select *
from exams_q_40;

with
    cte1
    as
    (
        select student_id, score, exam_id
, RANK() over (PARTITION by exam_id order by score desc) as rnk
, count(1) over (PARTITION by exam_id) as cnt
        from exams_q_40
    )

,
    cte2
    as
    (
                    SELECT *
            from cte1
            where rnk=cnt
        UNION ALL
            select *
            from cte1
            where rnk=1
    )
select distinct c.student_id
, s.student_name
from cte1 c
    left JOIN
    cte2
    on cte2.student_id = c.student_id
    join students_q_40 s
    on s.student_id = c.student_id
where cte2.score is NULL;

with
    grp_cte
    as
    (
        select exam_id
, max(score) as max_val
, MIN(score) as min_val
        from exams_q_40
        group by exam_id
    )

select e2.student_id
, max(s.student_name)
from exams_q_40 e2
    join grp_cte g
    on g.exam_id = e2.exam_id
    join students_q_40 s
    on s.student_id = e2.student_id
-- and e2.score < g.max_val and e2.score > g.min_val
group by e2.student_id
having max(case when score = min_val or score = max_val then 1 else 0 end) = 0
