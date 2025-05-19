SELECT *
FROM bq.events
WHERE platform = 'ANDROID'
  AND toDate(event_date) BETWEEN '2024-02-02' AND '2024-02-20'
  AND hasAny(firebase_experiments, ['firebase_exp_84_0', 'firebase_exp_84_1'])

