CREATE OR REPLACE PROCEDURE chatbot_transformer_forecast_response(
    p_user_query IN VARCHAR2, 
    p_response OUT CLOB
) IS
    v_predicted_cpu NUMBER;
    v_predicted_sessions NUMBER;
    v_alert_msg VARCHAR2(500);
    v_advice VARCHAR2(500);
BEGIN
    v_predicted_cpu := ml_forecast_transformer('CPU Usage (%)');
    v_predicted_sessions := ml_forecast_transformer('Active Sessions');

    IF v_predicted_cpu > 85 THEN
        v_alert_msg := 'Transformer AI: High CPU usage predicted (' || v_predicted_cpu || '%).';
        v_advice := 'Optimize queries and consider autoscaling.';
    ELSIF v_predicted_sessions > 250 THEN
        v_alert_msg := 'AI Forecast: Surge in sessions expected (' || v_predicted_sessions || ').';
        v_advice := 'Increase connection pool size.';
    ELSE
        v_alert_msg := 'No major workload spikes expected.';
        v_advice := 'Monitor system normally.';
    END IF;

    p_response := v_alert_msg || ' Suggested action: ' || v_advice;
END chatbot_transformer_forecast_response;
/