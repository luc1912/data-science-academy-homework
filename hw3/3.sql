-- target table
CREATE TABLE lrunjic.daily_event_openings(
    event_date Date,
    event_id Int32,
    count Int32
) ENGINE = SummingMergeTree()
ORDER BY (event_date,event_id)
SETTINGS index_granularity = 8192;

-- materialized view
CREATE MATERIALIZED VIEW lrunjic.mv_daily_event_openings
TO lrunjic.daily_event_openings
AS
SELECT
    toDate(event_date) AS event_date,
    id AS event_id,
    COUNT(*) AS count
FROM
    bq.events
WHERE event_name = 'open_event'
GROUP BY event_date, event_id;

-- Populating target table manually
INSERT INTO lrunjic.daily_event_openings
SELECT
    toDate(event_date) AS event_date,
    id AS event_id,
    COUNT(*) AS count
FROM
    bq.events
WHERE event_name = 'open_event'
GROUP BY event_date, event_id;