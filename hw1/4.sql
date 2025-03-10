select ss.name as sport, count(*)
from bq.events bqe
join sports.event se on bqe.id = se.id
join sports.sport ss on se.sport_id = ss.id
where bqe.event_name like 'open_event'
and toMonth(toDate(bqe.event_date)) = 1
group by ss.name
order by count(*) desc;