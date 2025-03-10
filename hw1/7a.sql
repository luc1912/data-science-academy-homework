select event_date
from lrunjic.daily_user_activity
group by event_date
order by count(distinct user_pseudo_id) desc
limit 1;

-- ili

select event_date
from lrunjic.daily_event_activity
order by distinct_user_count desc
limit 1;