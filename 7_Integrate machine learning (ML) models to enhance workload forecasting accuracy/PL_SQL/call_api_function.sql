CREATE OR REPLACE FUNCTION ml_forecast_metric (
    p_metric_name VARCHAR2,
    p_timeframe INTERVAL DAY TO SECOND
) RETURN NUMBER IS
    v_prediction NUMBER;
    v_api_url VARCHAR2(500) := 'http://your_python_server:5000/predict';
    v_timestamp NUMBER;
    v_response CLOB;
BEGIN
    -- Get current UNIX timestamp
    SELECT EXTRACT(EPOCH FROM SYSTIMESTAMP + p_timeframe) INTO v_timestamp FROM DUAL;

    -- Call Python API to get the prediction
    v_response := http_request(v_api_url, 'POST', '{"timestamp": ' || v_timestamp || '}');
    
    -- Extract predicted value
    v_prediction := JSON_VALUE(v_response, '$.predicted_value');
    
    RETURN v_prediction;
END ml_forecast_metric;
/