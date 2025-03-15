CREATE OR REPLACE PROCEDURE chatbot_performance_check(
    p_user_query IN VARCHAR2, 
    p_response OUT CLOB
) IS
    v_alert VARCHAR2(500);
    v_recommendation VARCHAR2(500);
BEGIN
    -- Detect anomalies
    v_alert := detect_performance_anomalies;

    -- Provide optimization recommendations
    IF v_alert LIKE 'Warning: CPU%' THEN
        v_recommendation := 'Consider tuning expensive SQL queries or reviewing parallel execution plans.';
    ELSIF v_alert LIKE 'Warning: Active%' THEN
        v_recommendation := 'Check for long-running transactions or blocking sessions using V$SESSION.';
    ELSE
        v_recommendation := 'No issues detected. Keep monitoring.';
    END IF;

    -- Generate chatbot response
    p_response := v_alert || ' Suggested action: ' || v_recommendation;
END chatbot_performance_check;
/
