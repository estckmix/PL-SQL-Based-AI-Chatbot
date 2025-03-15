BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'COLLECT_METRICS_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN collect_system_metrics; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=MINUTELY; INTERVAL=5',
        enabled         => TRUE
    );
END;
/
