-- In this probelem, we want to find the person whose friends individual marks sum is > 100 

-- create table person
-- (
-- PersonID int,
-- Names varchar(10),
-- Email varchar(50),
-- Score int
-- );

-- delete from person;
-- insert into person values
-- (1,'Alice','alice2018@hotmail.com',88),
-- (2,'Bob','bob2018@hotmail.com',11),
-- (3,'Davis','davis2018@hotmail.com',27),
-- (4,'Tara','tara2018@hotmail.com',45),
-- (5,'John','john2018@hotmail.com',63)

-- create table friend
-- (
-- PersonID int,
-- FriendID int
-- );
-- delete from friend;
-- insert into friend values
-- (1,2),
-- (1,3),
-- (2,1),
-- (2,3),
-- (3,5),
-- (4,2),
-- (4,3),
-- (4,5)

select *
from friend;
SELECT *
from person;

with
    cte1
    AS
    (
        select f.PersonId, count(1) as no_of_friends, Sum(score) as total_friendscore
        from friend f
            join person p
            on f.FriendID = p.personId
        GROUP by f.PersonId
    )
--having Sum(score)  > 100)
SELECT cte1.personId, p.names , no_of_friends, total_friendscore
from cte1
    join Person p
    on p.personID = cte1.personID
where total_friendscore > 100


-- WAY 2
-- select * from person;
-- select * from friend;

with
    cte1
    as
    (
        select f.personid, p.names, friendid , Score
, sum(score) over (PARTITION by f.personid) as  friends_total_score
, count(1) over (PARTITION by f.personid) as count_of_friends
        from person p
            join friend f
            on p.PersonID = f.FriendID
    )
select c.personid
, MAX(p.names) as person_name
, max(friends_total_score) as total_friends_marks
, max(count_of_friends) as number_of_friends
from cte1 c
    join person p on 
p.PersonID = c.PersonID and c.friends_total_score > 100
group by c.PersonID 
