CREATE OR REPLACE PROCEDURE collect_system_metrics AS
BEGIN
    -- Capture CPU usage
    INSERT INTO system_performance_metrics (metric_name, metric_value)
    SELECT 'CPU Usage (%)', value
    FROM v$sysmetric
    WHERE metric_name = 'CPU Usage Per Sec';

    -- Capture active sessions
    INSERT INTO system_performance_metrics (metric_name, metric_value)
    SELECT 'Active Sessions', COUNT(*) FROM v$session WHERE status = 'ACTIVE';

    -- Capture memory usage
    INSERT INTO system_performance_metrics (metric_name, metric_value)
    SELECT 'SGA Memory (MB)', value / 1024 / 1024
    FROM v$sga;

    COMMIT;
END collect_system_metrics;
/
