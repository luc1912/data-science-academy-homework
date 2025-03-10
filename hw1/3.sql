select count(distinct user_pseudo_id) as broj_korisnika
from bq.events bqe
where bqe.event_name like 'drawer_action'
and bqe.item_name like 'Buzzer Feed';