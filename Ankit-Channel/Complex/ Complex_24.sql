/*FIND COMPANIES WHO HAVE ATKEAST 2 USERS WHO SPEAK ENGLISH AND GERMAN BOTH
*/

select *
from company_users;
with
    cte1
    AS
    (
        select company_id , user_id, count(1) as lang_count
        from company_users
        WHERE language in ('English','German')
        group by company_id, user_id
    )
select company_id
from cte1
where lang_count = 2
group by company_id
having count(company_id) >=2