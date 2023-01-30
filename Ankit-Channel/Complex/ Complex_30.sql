-- PIVOT the city column and display results.
select *
from players_location;

-- Generate a third column to make it eligible for PIVOTING, For better readability using CTE for same
with
    cte
    as
    (
        select *, ROW_NUMBER() OVER(partition by city order by name) as rn
        from players_location
    )

-- PIVOT logic leveraging the above cte
select Bangalore, Mumbai, Delhi
from
    (select rn, name, city
    from cte) as a
PIVOT (
    min(name)
FOR city in (Bangalore, Mumbai,Delhi )
) as PVT

-- Example to prove he above concept that a third column is needed to make it eligible for PIVOT approach.
-- create table players_location_copy
-- (
-- name varchar(20),
-- year int,
-- city varchar(20)
-- );
-- delete from players_location_copy;
-- insert into players_location_copy
-- values ('Sachin',2010,'Mumbai'),('Virat',2011,'Delhi') , ('Rahul',2010,'Bangalore'),('Rohit',2011,'Mumbai'),('Mayank',2012,'Bangalore');
-- update players_location_copy set year = 2010 where name = 'Rohit'
select *
from players_location_copy;
select year, Bangalore, Mumbai, Delhi
from
    (select year, name, city
    from players_location_copy) as a
PIVOT (
    count(name)
FOR city in (Bangalore, Mumbai,Delhi )
) as PVT
