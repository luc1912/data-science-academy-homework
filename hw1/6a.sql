create table lrunjic.monthly_user_activity (
    event_date date,
    event_name LowCardinality(String),
    user_pseudo_id String,
    geo_country LowCardinality(String) default '',
    platform Enum8('unknown' = 0, 'android' = 1, 'ios' = 2, 'web' = 3) default 'unknown',
    count Int32
) engine = MergeTree()
order by (event_date, event_name, user_pseudo_id, geo_country, platform);

insert into lrunjic.monthly_user_activity
select
    toStartOfMonth(toDate(event_date)) AS event_date,
    event_name,
    user_pseudo_id,
    geo_country,
    platform,
    count(*) AS count
from bq.events
where toDate(event_date) >= '2024-02-01' and toDate(event_date) < '2024-03-01'
group by event_date, event_name, user_pseudo_id, geo_country, platform;

create table lrunjic.daily_user_activity (
    event_date date,
    event_name LowCardinality(String),
    user_pseudo_id String,
    geo_country LowCardinality(String) default '',
    platform Enum8('unknown' = 0, 'android' = 1, 'ios' = 2, 'web' = 3) default 'unknown',
    count Int32
) engine = MergeTree()
order by (event_date, event_name, user_pseudo_id, geo_country, platform);

insert into lrunjic.daily_user_activity
select
    toStartOfDay(toDate(event_date)) AS event_date,
    event_name,
    user_pseudo_id,
    geo_country,
    platform,
    count(*) AS count
from bq.events
where toDate(event_date) >= '2024-02-01' and toDate(event_date) < '2024-03-01'
group by event_date, event_name, user_pseudo_id, geo_country, platform;
