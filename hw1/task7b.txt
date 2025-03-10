select event_date
from lrunjic.daily_event_activity
where event_name = 'open_event' and geo_country = 'Croatia'
order by event_count desc
limit 1;