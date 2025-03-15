-- 1. Test Data Collection from DBA_HIST_ACTIVE_SESS_HISTORY
SELECT sample_time, session_id, sql_id, session_state 
FROM DBA_HIST_ACTIVE_SESS_HISTORY 
WHERE rownum <= 10;

-- 2. Test Data Collection from DBA_HIST_SYSMETRIC_HISTORY
SELECT begin_time, metric_name, value 
FROM DBA_HIST_SYSMETRIC_HISTORY 
WHERE metric_name IN ('CPU Usage Per Sec', 'Average Active Sessions')
AND rownum <= 10;

-- 3. Test AI Forecast Procedure Execution
BEGIN
    forecast_based_alert;
END;
/

-- 4. Validate Forecast Table Entries
SELECT * FROM workload_forecast_results
ORDER BY forecast_time DESC
FETCH FIRST 10 ROWS ONLY;

-- 5. Check for Scheduled Job Execution Logs
SELECT log_id, job_name, status, log_date
FROM DBA_SCHEDULER_JOB_RUN_DETAILS
WHERE job_name = 'FORECAST_ALERT_JOB'
ORDER BY log_date DESC
FETCH FIRST 10 ROWS ONLY;

-- 6. Verify Alerts Were Triggered (if any)
SELECT alert_id, alert_message, alert_time
FROM forecast_alert_logs
ORDER BY alert_time DESC
FETCH FIRST 10 ROWS ONLY;
