BEGIN
    DBMS_SCHEDULER.create_job (
        job_name        => 'ML_FORECAST_JOB',
        job_type        => 'EXECUTABLE',
        job_action      => '/usr/bin/python3 /path/to/ml_forecast.py',
        start_date      => SYSTIMESTAMP,
        repeat_interval => 'FREQ=MINUTELY; INTERVAL=30',
        enabled         => TRUE
    );
END;
/