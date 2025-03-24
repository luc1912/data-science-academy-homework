-- target table
CREATE TABLE lrunjic.daily_entity_follows
(
    event_date Date,
    entity ENUM('league' = 1, 'player' = 2, 'team' = 3),
    name String,
    count Int32
) ENGINE = SummingMergeTree()
ORDER BY (event_date, entity, name)
SETTINGS index_granularity = 8192;

-- materialized view
CREATE MATERIALIZED VIEW lrunjic.mv_daily_entity_follows
TO lrunjic.daily_entity_follows
AS
SELECT
    toDate(event_date) as event_date,
    multiIf(
        event_name = 'follow_league','league',
        event_name = 'follow_player','player',
        event_name = 'follow_team','team',
        ''
        ) as entity,
     multiIf(
        event_name = 'follow_league', dictGet('lrunjic.tournament_dictionary', 'name', toUInt32(id)),
        event_name = 'follow_player', dictGet('lrunjic.player_dictionary', 'name', toUInt32(id)),
        event_name = 'follow_team', dictGet('lrunjic.team_dictionary', 'name', toUInt32(id)),
        ''
    ) as name,
    count(*) as count
FROM bq.events
where event_name in ('follow_team', 'follow_player', 'follow_league')
GROUP BY event_date, entity, name;

-- Populating target table manually
INSERT INTO lrunjic.daily_entity_follows
SELECT
    toDate(event_date) AS event_date,
    multiIf(
        event_name = 'follow_league', 'league',
        event_name = 'follow_player', 'player',
        event_name = 'follow_team', 'team',
        ''
    ) AS entity,
    multiIf(
        event_name = 'follow_league', dictGet('lrunjic.tournament_dictionary', 'name', toUInt32(id)),
        event_name = 'follow_player', dictGet('lrunjic.player_dictionary', 'name', toUInt32(id)),
        event_name = 'follow_team', dictGet('lrunjic.team_dictionary', 'name', toUInt32(id)),
        ''
    ) AS name,
    count(*) AS count
FROM bq.events
WHERE event_name IN ('follow_team', 'follow_player', 'follow_league')
GROUP BY event_date, entity, name;

