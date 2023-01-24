-- try to find player who has won only gold medals and count the number of golds won.
select *
from events;
with
    CTE1
    as
    
    (
        select e1.gold, e2.silver, e3.bronze
        from events e1
            left join events e2
            on e1.gold = e2.silver
            left join events e3
            on e1.gold = e3.bronze
        where e2.silver is NULL
    )
select gold player, count(gold) as no_of_gold
from CTE1
where bronze is NULL
group by gold

--SELECT gold Players, count(gold) as no_of_gold
-- from events 
-- GROUP BY gold;