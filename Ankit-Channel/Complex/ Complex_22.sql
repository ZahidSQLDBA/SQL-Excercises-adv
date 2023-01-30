/*
find students with same marks in physics and chemistry
*/

select *
from exams;
-- way 1
with
    cte1
    AS
    (
        select student_id
, case when subject = 'Chemistry' then marks end as chem_marks
, case when subject = 'Physics' then marks end as phy_marks
        from exams
    )
select student_id
from
    (select student_id, max(chem_marks) as chem_marks, max(phy_marks) as phy_marks
    from cte1
    group by student_id) a
where chem_marks = phy_marks

--way 2
select student_id
from exams
where subject in ('Physics', 'Chemistry')
group by student_id
having count(distinct subject) = 2
    and count(distinct marks) =1