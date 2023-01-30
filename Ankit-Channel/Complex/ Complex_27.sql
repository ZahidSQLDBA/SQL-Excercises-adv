select *
from students;
-- Write SQL to get list of students with marks more than avergae marks in each subject.

-- select subject, AVG(marks) as avg_marks
-- from students
-- group by  subject

select studentname, subject, marks
from
    (select *, AVG(marks) over (partition by subject order by subject) as avg_marks
    from students) a
where marks > avg_marks

-- Write a SQL query to get % of students who score more than 90 in any subject amongst total students
SELECT
    (count(distinct case when marks > 90 then studentid else null END) * 100.0) /
count(distinct studentid) as perc
from students

-- Write SQL query to get second highest and second lowest marks  for each subject
select *
from students;
with
    cte1
    AS
    (
        select *
, RANK() OVER(partition by subject order by marks desc) as high_marks
, RANK() OVER(partition by subject order by marks) as low_marks
        from students
    )
select subject
, max(case when high_marks = 2 then marks end) as second_highest_marks
, max(case when low_marks = 2 then marks end) as second_lowest_marks
from cte1
group by subject

-- for each student and test, identify if their marks increased or decreased from previous test
select *
from students;
with
    cte1
    as
    (
        SELECT *
 , LAG(marks,1) over (PARTITION by studentid order by testdate,subject) as lag_marks
        from students
    )
select studentname
 , case when marks > lag_marks then 'Increased'
 when lag_marks > marks then 'Decreased' END as result
from cte1
