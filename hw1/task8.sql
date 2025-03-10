with followed_players as (
    select bqe.geo_country, bqe.name AS player_name, count(*) AS numer_of_followings
    from bq.events bqe
    where bqe.event_name = 'follow_player' and toMonth(toDate(bqe.event_date)) = 2
    group by bqe.geo_country, bqe.name
),
max_followed as (
    select geo_country, max(numer_of_followings) as max_followings
    from followed_players
    group by geo_country
)
select fp.geo_country, fp.player_name
from followed_players fp
join max_followed mf
    on fp.geo_country = mf.geo_country and fp.numer_of_followings = mf.max_followings;