CREATE TABLE workload_time_series AS 
SELECT metric_name, metric_value, collection_time 
FROM system_performance_metrics 
WHERE collection_time >= SYSTIMESTAMP - INTERVAL '90' DAY
ORDER BY collection_time;