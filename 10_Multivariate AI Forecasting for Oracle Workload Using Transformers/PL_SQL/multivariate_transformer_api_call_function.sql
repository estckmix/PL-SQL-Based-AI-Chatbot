CREATE OR REPLACE FUNCTION ml_forecast_multivariate (
    p_metric_names VARCHAR2
) RETURN CLOB IS
    v_response CLOB;
    v_sequence CLOB;
    v_api_url VARCHAR2(500) := 'http://your_python_server:5000/predict_multivariate';
    v_prediction CLOB;
BEGIN
    -- Fetch last 24 workload values for multiple metrics
    SELECT JSON_ARRAYAGG(
        JSON_OBJECT('CPU Usage (%)' VALUE cpu_usage, 
                    'Active Sessions' VALUE active_sessions, 
                    'Buffer Cache Hit Ratio' VALUE buffer_cache,
                    'Disk I/O Throughput' VALUE disk_io,
                    'Redo Log Wait Time' VALUE log_wait_time)
        ORDER BY collection_time) 
    INTO v_sequence
    FROM (SELECT * FROM workload_multivariate_series 
          WHERE metric_name IN ('CPU Usage (%)', 'Active Sessions', 'Buffer Cache Hit Ratio', 'Disk I/O Throughput', 'Redo Log Wait Time') 
          ORDER BY collection_time DESC FETCH FIRST 24 ROWS ONLY);

    -- Call Transformer API
    v_response := http_request(v_api_url, 'POST', '{"sequence": ' || v_sequence || '}');

    -- Extract predicted workload values
    v_prediction := JSON_VALUE(v_response, '$');

    RETURN v_prediction;
END ml_forecast_multivariate;
/