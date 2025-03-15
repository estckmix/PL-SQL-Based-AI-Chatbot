CREATE OR REPLACE PROCEDURE chatbot_ml_forecast_response(
    p_user_query IN VARCHAR2, 
    p_response OUT CLOB
) IS
    v_predicted_cpu NUMBER;
    v_predicted_sessions NUMBER;
    v_alert_msg VARCHAR2(500);
    v_advice VARCHAR2(500);
BEGIN
    -- Get AI-powered workload forecasts
    v_predicted_cpu := ml_forecast_metric('CPU Usage (%)', INTERVAL '1' HOUR);
    v_predicted_sessions := ml_forecast_metric('Active Sessions', INTERVAL '1' HOUR);

    -- Check for overload risks
    IF v_predicted_cpu > 80 THEN
        v_alert_msg := 'AI Forecast: High CPU usage predicted (' || v_predicted_cpu || '%).';
        v_advice := 'Consider scaling up resources or optimizing SQL execution plans.';
    ELSIF v_predicted_sessions > 200 THEN
        v_alert_msg := 'AI Forecast: Surge in active sessions expected (' || v_predicted_sessions || ').';
        v_advice := 'Check application load balancing and tune long-running queries.';
    ELSE
        v_alert_msg := 'No critical workload spikes predicted.';
        v_advice := 'Keep monitoring system performance.';
    END IF;

    -- Generate chatbot response
    p_response := v_alert_msg || ' Suggested action: ' || v_advice;
END chatbot_ml_forecast_response;
/