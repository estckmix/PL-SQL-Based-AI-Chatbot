CREATE OR REPLACE PROCEDURE database_health_report(p_report OUT CLOB) IS
    v_sessions NUMBER;
    v_memory NUMBER;
    v_cpu_usage NUMBER;
BEGIN
    -- Fetch health metrics
    SELECT active_sessions, shared_pool_mb, memory_usage_pct, cpu_usage_pct 
    INTO v_sessions, v_memory, v_cpu_usage 
    FROM db_health_metrics;
    
    -- Construct the report
    p_report := 'Database Health Report:' || CHR(10) ||
                '- Active Sessions: ' || v_sessions || CHR(10) ||
                '- Shared Pool Memory: ' || v_memory || ' MB' || CHR(10) ||
                '- Memory Usage: ' || v_cpu_usage || '%' || CHR(10);
EXCEPTION
    WHEN OTHERS THEN
        p_report := 'Error generating health report: ' || SQLERRM;
END database_health_report;
/