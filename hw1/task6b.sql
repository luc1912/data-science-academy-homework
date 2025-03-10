create table lrunjic.monthly_event_activity (
    event_date date,
    event_name LowCardinality(String),
    geo_country LowCardinality(String) default '',
    platform Enum8('unknown' = 0, 'android' = 1, 'ios' = 2, 'web' = 3, '<all>' = 4) default 'unknown',
    event_count Int32,
    distinct_user_count Int32
) engine = MergeTree()
order by (event_date, event_name, geo_country, platform);

insert into lrunjic.monthly_event_activity
select
    event_date,
    event_name,
    geo_country,
    platform,
    count(*) as event_count,
    count(distinct user_pseudo_id) as distinct_user_count
from lrunjic.monthly_user_activity
group by event_date, event_name, geo_country, platform

union all

select
    event_date,
    '<all>' as event_name,
    geo_country,
    platform,
    count(*) as event_count,
    count(distinct user_pseudo_id) as distinct_user_count
from lrunjic.monthly_user_activity
group by event_date, geo_country, platform

union all

select
    event_date,
    event_name,
    '<all>' as geo_country,
    platform,
    count(*) as event_count,
    count(distinct user_pseudo_id) as distinct_user_count
from lrunjic.monthly_user_activity
group by event_date, event_name, platform

union all

select
    event_date,
    event_name,
    geo_country,
    '<all>' as platform,
    count(*) as event_count,
    count(distinct user_pseudo_id) as distinct_user_count
from lrunjic.monthly_user_activity
group by event_date, event_name, geo_country;


create table lrunjic.daily_event_activity (
    event_date date,
    event_name LowCardinality(String),
    geo_country LowCardinality(String) default '',
    platform Enum8('unknown' = 0, 'android' = 1, 'ios' = 2, 'web' = 3, '<all>' = 4) default 'unknown',
    event_count Int32,
    distinct_user_count Int32
) engine = MergeTree()
order by (event_date, event_name, geo_country, platform);

insert into lrunjic.daily_event_activity
select
    event_date,
    event_name,
    geo_country,
    platform,
    count(*) as event_count,
    count(distinct user_pseudo_id) as distinct_user_count
from lrunjic.daily_user_activity
group by event_date, event_name, geo_country, platform

union all

select
    event_date,
    '<all>' as event_name,
    geo_country,
    platform,
    count(*) as event_count,
    count(distinct user_pseudo_id) as distinct_user_count
from lrunjic.daily_user_activity
group by event_date, geo_country, platform

union all

select
    event_date,
    event_name,
    '<all>' as geo_country,
    platform,
    count(*) as event_count,
    count(distinct user_pseudo_id) as distinct_user_count
from lrunjic.daily_user_activity
group by event_date, event_name, platform

union all

select
    event_date,
    event_name,
    geo_country,
    '<all>' as platform,
    count(*) as event_count,
    count(distinct user_pseudo_id) as distinct_user_count
from lrunjic.daily_user_activity
group by event_date, event_name, geo_country;