CREATE OR REPLACE FUNCTION ml_forecast_lstm (
    p_metric_name VARCHAR2
) RETURN NUMBER IS
    v_response CLOB;
    v_sequence CLOB;
    v_api_url VARCHAR2(500) := 'http://your_python_server:5000/predict_lstm';
    v_prediction NUMBER;
BEGIN
    -- Fetch last 24 workload values
    SELECT JSON_ARRAYAGG(metric_value ORDER BY collection_time) INTO v_sequence
    FROM (SELECT metric_value FROM workload_time_series WHERE metric_name = p_metric_name ORDER BY collection_time DESC FETCH FIRST 24 ROWS ONLY);

    -- Call LSTM API
    v_response := http_request(v_api_url, 'POST', '{"sequence": ' || v_sequence || '}');
    
    -- Extract predicted value
    v_prediction := JSON_VALUE(v_response, '$.predicted_value');
    
    RETURN v_prediction;
END ml_forecast_lstm;
/