CREATE VIEW db_health_metrics AS
SELECT 
    (SELECT COUNT(*) FROM v$session) AS active_sessions,
    (SELECT ROUND(SUM(bytes)/1024/1024, 2) FROM v$sgastat WHERE pool='shared pool') AS shared_pool_mb,
    (SELECT ROUND((SUM(used_bytes)/SUM(allocated_bytes))*100, 2) FROM v$sgainfo WHERE name LIKE 'SGA%') AS memory_usage_pct,
    (SELECT ROUND((SELECT value FROM v$sysmetric WHERE metric_name = 'CPU Usage Per Sec'), 2)) AS cpu_usage_pct
FROM dual;