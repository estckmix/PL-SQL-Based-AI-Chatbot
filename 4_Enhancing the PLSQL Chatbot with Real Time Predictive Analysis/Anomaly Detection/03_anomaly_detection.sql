CREATE OR REPLACE FUNCTION detect_performance_anomalies RETURN VARCHAR2 IS
    v_cpu_usage NUMBER;
    v_cpu_baseline NUMBER;
    v_sessions NUMBER;
    v_session_baseline NUMBER;
    v_alert_msg VARCHAR2(500);
BEGIN
    -- Get latest CPU usage
    SELECT metric_value INTO v_cpu_usage
    FROM system_performance_metrics
    WHERE metric_name = 'CPU Usage (%)'
    ORDER BY collection_time DESC FETCH FIRST 1 ROW ONLY;

    -- Get average CPU usage over the last 1 hour
    SELECT AVG(metric_value) INTO v_cpu_baseline
    FROM system_performance_metrics
    WHERE metric_name = 'CPU Usage (%)' 
    AND collection_time >= SYSTIMESTAMP - INTERVAL '1' HOUR;

    -- Get latest active session count
    SELECT metric_value INTO v_sessions
    FROM system_performance_metrics
    WHERE metric_name = 'Active Sessions'
    ORDER BY collection_time DESC FETCH FIRST 1 ROW ONLY;

    -- Get average active sessions over the last 1 hour
    SELECT AVG(metric_value) INTO v_session_baseline
    FROM system_performance_metrics
    WHERE metric_name = 'Active Sessions' 
    AND collection_time >= SYSTIMESTAMP - INTERVAL '1' HOUR;

    -- Detect anomalies
    IF v_cpu_usage > (v_cpu_baseline * 1.5) THEN
        v_alert_msg := 'Warning: CPU usage has spiked (' || v_cpu_usage || '%). Check system load.';
    ELSIF v_sessions > (v_session_baseline * 2) THEN
        v_alert_msg := 'Warning: Active sessions doubled (' || v_sessions || '). Possible overload.';
    ELSE
        v_alert_msg := 'System is stable.';
    END IF;

    RETURN v_alert_msg;
END detect_performance_anomalies;
/
