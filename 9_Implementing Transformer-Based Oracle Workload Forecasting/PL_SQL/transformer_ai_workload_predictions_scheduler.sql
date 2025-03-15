BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'TRANSFORMER_AI_WORKLOAD_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN generate_transformer_workload_forecast; END;',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=MINUTELY; INTERVAL=30',
        enabled         => TRUE
    );
END;
/