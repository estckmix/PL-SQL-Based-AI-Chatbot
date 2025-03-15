CREATE TABLE workload_history AS 
SELECT metric_name, metric_value, collection_time 
FROM system_performance_metrics 
WHERE collection_time >= SYSTIMESTAMP - INTERVAL '30' DAY;