CREATE TABLE workload_multivariate_series AS 
SELECT collection_time, 
       EXTRACT(DAY FROM collection_time) AS day_of_month,
       TO_CHAR(collection_time, 'D') AS day_of_week,
       EXTRACT(HOUR FROM collection_time) AS hour_of_day,
       metric_name,
       metric_value
FROM system_performance_metrics
WHERE metric_name IN ('CPU Usage (%)', 'Active Sessions', 'Buffer Cache Hit Ratio', 'Disk I/O Throughput', 'Redo Log Wait Time')
AND collection_time >= SYSTIMESTAMP - INTERVAL '90' DAY
ORDER BY collection_time;
