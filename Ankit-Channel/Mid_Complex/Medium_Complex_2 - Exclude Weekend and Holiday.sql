-- update holidays
-- SET HOLIDAY_DATE = '2022-08-07' WHERE REASON = 'Rakhi'

-- In this probelem we are trying to find, the number of actula business days taken to resolve an open ticket.
-- Business day means actual working days excluding Weekends and holidays.

with
    holidayCte
    as
    (
        select ticket_id, create_date, resolved_date, count(holiday_date) as no_of_holiday
        from tickets t
            left join holidays h
            on h.holiday_date between create_date and resolved_date
                and DATENAME(WEEKDAY, holiday_date) <> 'Sunday' and DATENAME(WEEKDAY, holiday_date) <> 'Saturday'
        GROUP by ticket_id, create_date, resolved_date
    )
select ticket_id, create_date, resolved_date,
    DATEDIFF(DAY, create_date, resolved_date) - 2*(DATEDIFF(WEEK,create_date, resolved_date)) - no_of_holiday as resolution_days
from holidayCte;