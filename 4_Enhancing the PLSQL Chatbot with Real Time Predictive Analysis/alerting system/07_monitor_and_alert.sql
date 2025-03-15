CREATE OR REPLACE PROCEDURE monitor_and_alert AS
    v_alert VARCHAR2(500);
BEGIN
    v_alert := detect_performance_anomalies;

    IF v_alert LIKE 'Warning%' THEN
        send_alert_email(v_alert);
    END IF;
END monitor_and_alert;
/

BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'PERFORMANCE_ALERT_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN monitor_and_alert; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=MINUTELY; INTERVAL=10',
        enabled         => TRUE
    );
END;
/