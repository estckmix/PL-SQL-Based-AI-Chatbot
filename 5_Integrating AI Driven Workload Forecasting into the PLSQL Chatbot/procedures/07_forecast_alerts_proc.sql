CREATE OR REPLACE PROCEDURE forecast_based_alert AS
    v_predicted_cpu NUMBER;
    v_predicted_sessions NUMBER;
    v_alert_msg VARCHAR2(500);
BEGIN
    -- Get latest forecasted values
    SELECT predicted_value INTO v_predicted_cpu
    FROM workload_forecast
    WHERE metric_name = 'CPU Usage (%)'
    ORDER BY forecast_time DESC FETCH FIRST 1 ROW ONLY;

    SELECT predicted_value INTO v_predicted_sessions
    FROM workload_forecast
    WHERE metric_name = 'Active Sessions'
    ORDER BY forecast_time DESC FETCH FIRST 1 ROW ONLY;

    -- Check for future overload risk
    IF v_predicted_cpu > 90 THEN
        v_alert_msg := 'CRITICAL: Predicted CPU usage exceeds 90% (' || v_predicted_cpu || '%). Immediate action required!';
        send_alert_email(v_alert_msg);
    ELSIF v_predicted_sessions > 250 THEN
        v_alert_msg := 'CRITICAL: Active sessions expected to exceed 250 (' || v_predicted_sessions || ').';
        send_alert_email(v_alert_msg);
    END IF;
END forecast_based_alert;
/

BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'FORECAST_ALERT_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN forecast_based_alert; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=HOURLY;',
        enabled         => TRUE
    );
END;
/