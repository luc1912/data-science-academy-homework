select bqe.id as id, count(*) as number_of_openings
from bq.events bqe
join sports.event se on se.id = bqe.id
join sports.tournament st on st.id = se.tournament_id
join sports.uniquetournament sut on st.uniquetournament_id = sut.id
where bqe.event_name like 'open_event'
and sut.name like 'HNL'
and toDate(bqe.event_date) between '2023-07-01' and '2024-06-30'
group by bqe.id
order by number_of_openings desc
limit 1;