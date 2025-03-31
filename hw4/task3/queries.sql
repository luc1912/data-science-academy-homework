-- bar chart
SELECT 
    eventDate, 
    COUNT(*) AS row_count 
FROM lrunjic.l4_dataset 
GROUP BY eventDate 
ORDER BY eventDate ASC

-- table
SELECT
    'l4_dataset' AS table_name,
    formatReadableSize(SUM(data_uncompressed_bytes)) AS total_uncompressed_size,
    formatReadableSize((SELECT total_bytes FROM system.tables WHERE database = 'lrunjic' AND name = 'l4_dataset')) AS total_compressed_size
FROM system.columns
WHERE database = 'lrunjic' AND table = 'l4_dataset';

-- pie chart
SELECT
    name AS column_name,
    data_uncompressed_bytes as value
FROM system.columns
WHERE database = 'lrunjic' AND table = 'l4_dataset';