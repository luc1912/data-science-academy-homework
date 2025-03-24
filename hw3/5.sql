-- daily event activity
CREATE TABLE lrunjic.daily_event_activity (
    event_date Date CODEC(DoubleDelta, LZ4),
    event_name LowCardinality(String) CODEC(ZSTD),
    geo_country LowCardinality(String) CODEC(ZSTD),
    platform String CODEC(ZSTD),
    event_count UInt64 CODEC(T64, LZ4),
    distinct_user_count UInt64 CODEC(T64, LZ4)
) ENGINE = SummingMergeTree()
ORDER BY (event_date, event_name, geo_country, platform);

INSERT INTO lrunjic.daily_event_activity
SELECT
    event_date,
    event_name,
    geo_country,
    platform,
    sum(count) AS event_count,
    count(DISTINCT user_pseudo_id) AS distinct_user_count
FROM aggregations.daily_user_activity
GROUP BY CUBE(event_date, event_name, geo_country, platform)
ORDER BY event_date, event_name, geo_country, platform;

-- monthly event activity
CREATE TABLE lrunjic.monthly_event_activity (
    event_date Date CODEC(DoubleDelta, LZ4),
    event_name LowCardinality(String) CODEC(ZSTD),
    geo_country LowCardinality(String) CODEC(ZSTD),
    platform String CODEC(ZSTD),
    event_count UInt64 CODEC(T64, LZ4),
    distinct_user_count UInt64 CODEC(T64, LZ4)
) ENGINE = SummingMergeTree()
ORDER BY (event_date, event_name, geo_country, platform);

INSERT INTO lrunjic.monthly_event_activity
SELECT
    toStartOfMonth(toDate(event_date)) AS event_date,
    event_name,
    geo_country,
    platform,
    sum(count) AS event_count,
    count(DISTINCT user_pseudo_id) AS distinct_user_count
FROM aggregations.monthly_user_activity
GROUP BY CUBE(event_date, event_name, geo_country, platform)
ORDER BY event_date, event_name, geo_country, platform;

