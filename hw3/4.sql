-- a
SELECT
    toMonday(event_date) AS week,
    dictGet('lrunjic.sport_dictionary', 'name', dictGet('lrunjic.event_dictionary', 'sport_id', event_id)) AS sport,
    SUM(count) AS weekly_count,
    dense_rank() OVER (PARTITION BY week ORDER BY SUM(count) DESC) AS rank
FROM lrunjic.daily_event_openings
WHERE event_date >= '2024-01-01' AND event_date < '2024-01-28'
GROUP BY week, sport
ORDER BY week, rank;

-- b
SELECT entity, name, SUM(count) AS total_follows
FROM lrunjic.daily_entity_follows
WHERE event_date BETWEEN '2024-01-15' AND '2024-01-21'
GROUP BY entity, name
ORDER BY total_follows DESC
LIMIT 10;


