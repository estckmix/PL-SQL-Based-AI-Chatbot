CREATE TABLE workload_time_series AS 
SELECT metric_name, 
       metric_value, 
       collection_time,
       EXTRACT(DAY FROM collection_time) AS day_of_month,
       TO_CHAR(collection_time, 'D') AS day_of_week,
       EXTRACT(HOUR FROM collection_time) AS hour_of_day
FROM system_performance_metrics 
WHERE collection_time >= SYSTIMESTAMP - INTERVAL '90' DAY
ORDER BY collection_time;