CREATE OR REPLACE PROCEDURE chatbot_forecast_response(
    p_user_query IN VARCHAR2, 
    p_response OUT CLOB
) IS
    v_predicted_cpu NUMBER;
    v_predicted_sessions NUMBER;
    v_alert_msg VARCHAR2(500);
    v_advice VARCHAR2(500);
BEGIN
    -- Fetch latest ML-based predictions
    SELECT predicted_value INTO v_predicted_cpu
    FROM workload_forecast
    WHERE metric_name = 'CPU Usage (%)'
    ORDER BY forecast_time DESC FETCH FIRST 1 ROW ONLY;

    SELECT predicted_value INTO v_predicted_sessions
    FROM workload_forecast
    WHERE metric_name = 'Active Sessions'
    ORDER BY forecast_time DESC FETCH FIRST 1 ROW ONLY;

    -- Check for future overload risk
    IF v_predicted_cpu > 85 THEN
        v_alert_msg := 'High CPU usage predicted: ' || v_predicted_cpu || '%.';
        v_advice := 'Consider increasing CPU capacity or tuning resource-intensive queries.';
    ELSIF v_predicted_sessions > 220 THEN
        v_alert_msg := 'Surge in active sessions expected: ' || v_predicted_sessions || '.';
        v_advice := 'Check connection pooling and optimize long-running transactions.';
    ELSE
        v_alert_msg := 'No critical workload spikes predicted.';
        v_advice := 'Keep monitoring system performance.';
    END IF;

    -- Generate chatbot response
    p_response := v_alert_msg || ' Suggested action: ' || v_advice;
END chatbot_forecast_response;
/
