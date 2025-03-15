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